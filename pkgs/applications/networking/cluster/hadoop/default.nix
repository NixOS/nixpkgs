{ stdenv, fetchurl, makeWrapper, pkgconfig, which, maven, cmake, jre, bash, nukeReferences
, coreutils, glibc, protobuf2_5, fuse, snappy, zstd, zlib, bzip2, openssl_1_0_2, openssl_1_1, isa-l, cyrus_sasl
}:

let
  common = { version, sources-sha256, dependencies-sha256, tomcat ? null, opensslPkg, extraBuildInputs ? [], patches ? [] }:
    let
      src = fetchurl {
        url = "mirror://apache/hadoop/common/hadoop-${version}/hadoop-${version}-src.tar.gz";
        sha256 = sources-sha256;
      };
      postUnpack = stdenv.lib.optionalString (tomcat != null) ''
        install -D ${tomcat.src} $sourceRoot/hadoop-hdfs-project/hadoop-hdfs-httpfs/downloads/apache-tomcat-${tomcat.version}.tar.gz
        install -D ${tomcat.src} $sourceRoot/hadoop-common-project/hadoop-kms/downloads/apache-tomcat-${tomcat.version}.tar.gz
      '';
      nativeBuildInputs = [ maven cmake pkgconfig ];
      buildInputs = [ fuse snappy zlib bzip2 opensslPkg protobuf2_5 ] ++ extraBuildInputs;
      mavenFlags = [ "-DskipTests" "-Pdist,native" "-e" ];

      # perform fake build to make a fixed-output derivation of dependencies downloaded from maven central (~100Mb in ~3000 files)
      fetched-maven-deps = stdenv.mkDerivation {
        pname = "hadoop-maven-deps";
        inherit version src postUnpack nativeBuildInputs buildInputs patches;
        dontConfigure = true; # do not trigger cmake hook
        buildPhase = ''
          while mvn package -Dmaven.repo.local=$out/.m2 ${stdenv.lib.escapeShellArgs mavenFlags} -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
            echo "timeout, restart maven to continue downloading"
          done
        '';
        # keep only *.{pom,jar,xml,sha1,so,dll,dylib} and delete all ephemeral files with lastModified timestamps inside
        installPhase = ''find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete'';
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
        outputHash = dependencies-sha256;
      };

      # compile the hadoop tarball from sources, it requires some patches
      binary-distributon = stdenv.mkDerivation {
        pname = "hadoop-bin";
        inherit version src postUnpack nativeBuildInputs buildInputs patches;
        # most of the hardcoded pathes are fixed in 2.9.x and 3.0.0, this list of patched files might be reduced when 2.7.x and 2.8.x will be deprecated
        postPatch = ''
          for file in hadoop-common-project/hadoop-common/src/main/java/org/apache/hadoop/fs/HardLink.java \
                      hadoop-common-project/hadoop-common/src/main/java/org/apache/hadoop/util/Shell.java \
                      hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-nodemanager/src/main/java/org/apache/hadoop/yarn/server/nodemanager/DefaultContainerExecutor.java \
                      hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-nodemanager/src/main/java/org/apache/hadoop/yarn/server/nodemanager/DockerContainerExecutor.java \
                      hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-nodemanager/src/main/java/org/apache/hadoop/yarn/server/nodemanager/containermanager/launcher/ContainerLaunch.java \
                      hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-core/src/main/java/org/apache/hadoop/mapreduce/MRJobConfig.java; do
            if [ -f "$file" ]; then
              substituteInPlace "$file" \
                --replace '/usr/bin/stat' 'stat' \
                --replace '/bin/bash'     'bash' \
                --replace '/bin/ls'       'ls'   \
                --replace '/bin/mv'       'mv'
            fi
          done
        '';
        dontConfigure = true; # do not trigger cmake hook
        buildPhase = ''
          # 'maven.repo.local' must be writable
          mvn package --offline -Dmaven.repo.local=$(cp -dpR ${fetched-maven-deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2 ${stdenv.lib.escapeShellArgs mavenFlags}
        '';
        installPhase = ''
          cp -R hadoop-dist/target/hadoop-${version} $out

          # Hadoop-3.2+ produces libhdfs at new location
          ${stdenv.lib.optionalString (stdenv.lib.versionAtLeast version "3.2") ''
              cp -d hadoop-hdfs-project/hadoop-hdfs-native-client/target/target/usr/local/lib/libhdfs.{a,so*}    $out/lib/native/
              cp -d hadoop-hdfs-project/hadoop-hdfs-native-client/target/main/native/libhdfspp/libhdfspp.{a,so*} $out/lib/native/
            ''}

          install -Dm755 hadoop-hdfs-project/${if stdenv.lib.versionOlder version "2.8" then
                                                "hadoop-hdfs/target/native"
                                               else
                                                "hadoop-hdfs-native-client/target"}/main/native/fuse-dfs/fuse_dfs $out/contrib/fuse-dfs/fuse_dfs

          # remove runtime dependency on build-time maven.jdk (on "''${maven.jdk}/jre/lib/amd64/server/libjvm.so")
          for f in $(find $out/lib/native -type f -executable); do
            # `strip -S` fails to strip debug info from libhadoop.so and libhdfs.so
            # all the references to Nix Store are in rpath and debug info, so nukeReferences can help here
            ${nukeReferences}/bin/nuke-refs "$f"

            patchelf --set-rpath ${stdenv.lib.makeLibraryPath ([glibc stdenv.cc.cc] ++ buildInputs)} "$f"
          done

          patchelf --set-rpath ${stdenv.lib.makeLibraryPath [glibc fuse]} "$out/contrib/fuse-dfs/fuse_dfs"
        '';
        disallowedReferences = [ maven.jdk ];
      };
    in
      stdenv.mkDerivation {
        pname = "hadoop";
        inherit version;

        src = binary-distributon;

        nativeBuildInputs = [ makeWrapper ];

        installPhase = ''
          mkdir -p $out/share/doc/hadoop
          cp -dpR * $out/
          mv $out/*.txt $out/share/doc/hadoop/

          #
          # Do not use `wrapProgram` here, script renaming may result to weird things: http://i.imgur.com/0Xee013.png
          #
          mkdir -p $out/bin.wrapped
          for n in $out/bin/*; do
            if [ -f "$n" ]; then # only regular files
              mv $n $out/bin.wrapped/
              makeWrapper $out/bin.wrapped/$(basename $n) $n \
                --prefix PATH            : "${stdenv.lib.makeBinPath [ which jre bash coreutils ]}" \
                --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath buildInputs}" \
                --set    JAVA_HOME         "${jre}" \
                --set    ${if stdenv.lib.versionOlder version "3.0" then "HADOOP_PREFIX" else "HADOOP_HOME"} "$out"
            fi
          done
          makeWrapper $out/contrib/fuse-dfs/fuse_dfs $out/bin/fuse_dfs_wrapper.sh \
            --set OS_ARCH         "amd64" \
            --set JAVA_HOME       "${jre}" \
            --set LD_LIBRARY_PATH "${jre}/jre/lib/amd64/server:$out/lib/native" \
            --set CLASSPATH       "$out/share/hadoop/hdfs/hadoop-hdfs-${version}.jar:$out/share/hadoop/hdfs/hadoop-hdfs-client-${version}.jar:$out/share/hadoop/common/hadoop-common-${version}.jar$(find $out/share/hadoop/{hdfs,common}/lib -type f -name '*.jar' -printf ':%p')"
        '';

        doInstallCheck = true;
        installCheckPhase = ''
          $out/bin/hadoop checknative
        '';

        meta = with stdenv.lib; {
          homepage = "http://hadoop.apache.org/";
          description = "Framework for distributed processing of large data sets across clusters of computers";
          license = licenses.asl20;

          longDescription = ''
            The Apache Hadoop software library is a framework that allows for
            the distributed processing of large data sets across clusters of
            computers using a simple programming model. It is designed to
            scale up from single servers to thousands of machines, each
            offering local computation and storage. Rather than rely on
            hardware to deliver high-avaiability, the library itself is
            designed to detect and handle failures at the application layer,
            so delivering a highly-availabile service on top of a cluster of
            computers, each of which may be prone to failures.
          '';
          maintainers = with maintainers; [ volth ];
          platforms = [ "x86_64-linux" ];
        };
      };

  tomcat_6_0_48 = rec {
    version = "6.0.48";
    src = fetchurl {
      # do not use "mirror://apache/" here, tomcat-6 is legacy and has been removed from the mirrors
      url = "https://archive.apache.org/dist/tomcat/tomcat-6/v${version}/bin/apache-tomcat-${version}.tar.gz";
      sha256 = "1w4jf28g8p25fmijixw6b02iqlagy2rvr57y3n90hvz341kb0bbc";
    };
  };

in {
  hadoop_2_7 = common {
    version = "2.7.7";
    sources-sha256 = "1ahv67f3lwak3kbjvnk1gncq56z6dksbajj872iqd0awdsj3p5rf";
    dependencies-sha256 = "13xlnj54q3xq247pa50mmvfc2w1pdlbk1a07nm9s27vw6jrllgww";
    tomcat = tomcat_6_0_48;
    opensslPkg = openssl_1_0_2;
  };
  hadoop_2_8 = common {
    version = "2.8.5";
    sources-sha256 = "0d1xbcdy5qgmh1gh5y8fv1gf0hpwgz3yzkpw6s0bc294bz2pzc35";
    dependencies-sha256 = "16hmzaxv52hisjc426dykls4p904sjknlmdmji5lp27pxvn0rkji";
    tomcat = tomcat_6_0_48;
    opensslPkg = openssl_1_0_2;
  };
  hadoop_2_9 = common {
    version = "2.9.2";
    sources-sha256 = "1nifslax1pgzg6xsny7m5dyg3d8vqfpbzr0dmlxhbwm70pxw62jr";
    dependencies-sha256 = "0jx51vsy1wa6mbcxfsgz07vdlwkg9n3pkp11dlpgivl0rr4krwij";
    tomcat = tomcat_6_0_48;
    opensslPkg = openssl_1_0_2;
    extraBuildInputs = [ zstd ];
  };
  hadoop_3_1 = common {
    version = "3.1.2";
    sources-sha256 = "1dn6pqwpq9jm5123fpmb85w6chds1pinpvcpfqyb3m3mzk4pgwh2";
    dependencies-sha256 = "0ml0ywn8fpjc14263f144d0vyhbn271pwamyml7d9jhvjk3qnh1h";
    opensslPkg = openssl_1_1;
    extraBuildInputs = [ zstd isa-l ];
  };
  hadoop_3_2 = common {
    version = "3.2.0";
    sources-sha256 = "0s2mfdph2psih6wynck59g7c909zgfg1ip7gjbl1id8j6y6l83f3";
    dependencies-sha256 = "1njvfa05d8170kd54wq9igv2vjfzh6sx5g0zaz9v1g29as8n6gb9";
    opensslPkg = openssl_1_1;
    extraBuildInputs = [ zstd isa-l cyrus_sasl ];
    patches = [
      # fix build of oom-killer
      # https://issues.apache.org/jira/browse/YARN-8498?focusedCommentId=16722705&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-16722705
      (fetchurl { url    = https://issues.apache.org/jira/secure/attachment/12951988/YARN-8948-01.patch;
                  sha256 = "1b51miimkv5ycgf9cpvhlxqfc285qa56w1h2mj5hnym6digk8zfm"; })
    ];
  };
}
