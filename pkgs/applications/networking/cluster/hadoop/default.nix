{ stdenv, fetchurl, makeWrapper, pkgconfig, which, maven, cmake, jre, bash, nukeReferences
, coreutils, glibc, protobuf2_5, protobuf3_7, fuse, snappy, zstd, zlib, bzip2, openssl_1_0_2, openssl_1_1, isa-l, cyrus_sasl
}:

let
  common = { version,
             sources-sha256,
             dependencies-sha256,
             tomcat ? null,
             protobufPkg,
             opensslPkg,
             extraBuildInputs ? [],
           }:
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
      buildInputs = [ fuse snappy zlib bzip2 opensslPkg protobufPkg ] ++ extraBuildInputs;
      mavenFlags = [ "-DskipTests" "-Pdist,native" "-e" ];

      # perform fake build to make a fixed-output derivation of dependencies downloaded from maven central (up to 500Mb)
      # $out/.m2                      - Maven cache
      # $out/xdg-cache-home/yarn/v1   - Yarn/NodeJS cache (optional)
      # $out/yarn.lock                - Yarn/NodeJS pinned dependencies (optional)
      fetched-maven-deps = stdenv.mkDerivation {
        pname = "hadoop-maven-deps";
        inherit version src postUnpack nativeBuildInputs buildInputs;
        dontConfigure = true; # do not trigger cmake hook
        buildPhase = ''
          # [since 3.3.0]: store downloaded .js files for yarn (of nodejs) cache
          export XDG_CACHE_HOME=$NIX_BUILD_TOP/xdg-cache-home

          while mvn package -Dmaven.repo.local=$NIX_BUILD_TOP/.m2 ${stdenv.lib.escapeShellArgs mavenFlags} -Dmaven.wagon.rto=''${NIX_CONNECT_TIMEOUT:-5}000; [ $? = 1 ]; do
            echo "restarting maven"

            # [since 2.10.1/3.1.4/3.3.0]: `mvn` fails at least once because executables downloaded from Maven cannot be executed until patched
            find . -type f -name 'protoc-*.exe' -executable -exec patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"                                                          {} \;
            find . -type f -name 'node'         -executable -exec patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${stdenv.lib.makeLibraryPath [stdenv.cc.cc]} {} \;
          done

          # keep only *.{pom,jar,xml,sha1,so,dll,dylib} and delete all ephemeral files with lastModified timestamps inside
          find $NIX_BUILD_TOP/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete
        '';
        installPhase = ''
          mkdir $out
          cp -r $NIX_BUILD_TOP/.m2 $out/
          if [ -d $NIX_BUILD_TOP/xdg-cache-home ]; then
            cp -r $NIX_BUILD_TOP/xdg-cache-home $out/;
          fi
          if [ -f hadoop-yarn-project/hadoop-yarn/hadoop-yarn-applications/hadoop-yarn-applications-catalog/hadoop-yarn-applications-catalog-webapp/yarn.lock ]; then
            cp hadoop-yarn-project/hadoop-yarn/hadoop-yarn-applications/hadoop-yarn-applications-catalog/hadoop-yarn-applications-catalog-webapp/yarn.lock $out/
          fi
        '';
        dontFixup = true; # do not shrink .so files
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
        outputHash = dependencies-sha256;
        impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars ++ [ "NIX_CONNECT_TIMEOUT" ];
        allowedReferences = [];
      };

      # compile the hadoop tarball from sources, it requires some patches
      binary-distributon = stdenv.mkDerivation {
        pname = "hadoop-bin";
        inherit version src postUnpack nativeBuildInputs buildInputs;
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
          # 'maven.repo.local' and yarn cache must be writable
          cp -r ${fetched-maven-deps} $NIX_BUILD_TOP/deps
          chmod +w -R $NIX_BUILD_TOP/deps

          # make downloaded executables runnable on NixOS
          find $NIX_BUILD_TOP/deps/.m2 -type f -name 'protoc-*.exe' -exec patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" {} \;
          for tgz in $(find $NIX_BUILD_TOP/deps/.m2 -type f -name 'node-*.tar.gz'); do
            ( cd $(dirname $tgz)
              tar xf $tgz
              find . -type f -name 'node' -executable -exec patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${stdenv.lib.makeLibraryPath [stdenv.cc.cc]} {} \;
              rm $tgz
              tar cfz $tgz *
            )
          done

          # [since 3.3.0]: downloaded .js files in yarn (of nodejs) cache
          export XDG_CACHE_HOME=$NIX_BUILD_TOP/deps/xdg-cache-home
          if [ -f $NIX_BUILD_TOP/deps/yarn.lock ]; then
            install -D $NIX_BUILD_TOP/deps/yarn.lock hadoop-yarn-project/hadoop-yarn/hadoop-yarn-applications/hadoop-yarn-applications-catalog/hadoop-yarn-applications-catalog-webapp/yarn.lock
          fi
          find . -type f -name 'pom.xml' -exec sed -i 's/>yarn install</>yarn install --offline</g' {} \;

          mvn package --offline -Dmaven.repo.local=$NIX_BUILD_TOP/deps/.m2 ${stdenv.lib.escapeShellArgs mavenFlags}
        '';
        installPhase = ''
          cp -R hadoop-dist/target/hadoop-${version} $out

          # Hadoop-3.2+ produces libhdfs at new location
          ${stdenv.lib.optionalString (stdenv.lib.versionAtLeast version "3.2") ''
              cp -d hadoop-hdfs-project/hadoop-hdfs-native-client/target/native/target/usr/local/lib/libhdfs.{a,so*}  $out/lib/native/
              cp -d hadoop-hdfs-project/hadoop-hdfs-native-client/target/main/native/libhdfspp/libhdfspp.{a,so*}      $out/lib/native/
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
      # `binary-distributon` bound to the runtime JRE
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

        # 3rd party applications using libhadoop.so should set $LD_LIBRARY_PATH to help its dlopen() locating libraries
        passthru.LD_LIBRARY_PATH    = stdenv.lib.makeLibraryPath buildInputs;
        passthru.protobuf           = protobufPkg;
        passthru.openssl            = opensslPkg;
        passthru.fetched-maven-deps = fetched-maven-deps;

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
          platforms = [ "x86_64-linux" ] ++ stdenv.lib.optional (stdenv.lib.versionAtLeast version "3.3") "aarch64-linux";
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

  tomcat_8_5_43 = rec {
    version = "8.5.43";
    src = fetchurl {
      # do not use "mirror://apache/" here, tomcat-8 is legacy and has been removed from the mirrors
      url = "https://archive.apache.org/dist/tomcat/tomcat-8/v${version}/bin/apache-tomcat-${version}.tar.gz";
      sha256 = "00xf5g55klmkv3lc6nlzpj8qdkg92r1qrnk1j6pirrxnqh6anljk";
    };
  };

in {
  hadoop_2_7 = common {
    version             = "2.7.7";
    sources-sha256      = "1ahv67f3lwak3kbjvnk1gncq56z6dksbajj872iqd0awdsj3p5rf";
    dependencies-sha256 = "1719jai4az4iyr4a2nz9b6pmb8ql2bbpyp40vsnhs6nwx3wsdf9c";
    tomcat              = tomcat_6_0_48;
    opensslPkg          = openssl_1_0_2;
    protobufPkg         = protobuf2_5;
  };
  hadoop_2_8 = common {
    version             = "2.8.5";
    sources-sha256      = "0d1xbcdy5qgmh1gh5y8fv1gf0hpwgz3yzkpw6s0bc294bz2pzc35";
    dependencies-sha256 = "0dr2i2j9qvnkqcras553s2m97q1v9ibkym8k47f7dj1xs0v04whr";
    tomcat              = tomcat_6_0_48;
    opensslPkg          = openssl_1_0_2;
    protobufPkg         = protobuf2_5;
  };
  hadoop_2_9 = common {
    version             = "2.9.2";
    sources-sha256      = "1nifslax1pgzg6xsny7m5dyg3d8vqfpbzr0dmlxhbwm70pxw62jr";
    dependencies-sha256 = "0r47p9mq7pwmma47rfh5in9fa3dc79zk7vp43fvcfgmbl08r54j2";
    tomcat              = tomcat_6_0_48;
    opensslPkg          = openssl_1_0_2;
    protobufPkg         = protobuf2_5;
    extraBuildInputs    = [ zstd ];
  };
  hadoop_2_10 = common {
    version             = "2.10.1";
    sources-sha256      = "04jmwjxq8hb52nmklswx3000hwnvi82pzmqwa5jkjyh31rbvq11w";
    dependencies-sha256 = "1lhn9aqk9wf4fh08nk1cm5l8ic341lr4fc6f8c5vf3653aqc997h";
    tomcat              = tomcat_8_5_43;
    opensslPkg          = openssl_1_0_2;
    protobufPkg         = protobuf2_5;
    extraBuildInputs    = [ zstd ];
  };
  hadoop_3_1 = common {
    version             = "3.1.4";
    sources-sha256      = "1syqfyd2f9zy6s7w5bhjkbz1xmrp63grw0mrn680n0lqkhj7kwzw";
    dependencies-sha256 = "0bc90yw6q2g3y5qlsmvzv5ph5s8a1aqfn7iab2frv64mcqw71s5l";
    opensslPkg          = openssl_1_1;
    protobufPkg         = protobuf2_5;
    extraBuildInputs    = [ zstd isa-l ];
  };
  hadoop_3_2 = common {
    version             = "3.2.1";
    sources-sha256      = "0903fpbgvx4fzccza9xagkw3ck2zbd0g2v9m337qbgs7q1bi7lrv";
    dependencies-sha256 = "09rq1d3v0cwia8lllpb6jxdma27f3f90pnkh96f5aj7ahyds8r66";
    opensslPkg          = openssl_1_1;
    protobufPkg         = protobuf2_5;
    extraBuildInputs    = [ zstd isa-l cyrus_sasl ];
  };
  hadoop_3_3 = common {
    version             = "3.3.0";
    sources-sha256      = "17qf2y6zxn387kjria7zh4y8h3zq3shwrmjjsfdrkq5i28dq7maz";
    dependencies-sha256 = { x86_64-linux  = "0wa7f3xdzrjsr1zj5v9j7p5m13415gi0v2w1zhwgzi7h86hkdqrg";
                            aarch64-linux = "sha256-JGZjDwMbGs2urUohVRyl6aKVN0AubnWT0skMoohCAE0=";
                          }.${stdenv.system};
    opensslPkg          = openssl_1_1;
    protobufPkg         = protobuf3_7;
    extraBuildInputs    = [ zstd isa-l cyrus_sasl ];
  };
}
