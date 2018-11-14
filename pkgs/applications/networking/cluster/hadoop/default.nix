{ stdenv, fetchurl, makeWrapper, pkgconfig, which, maven, cmake, jre, bash, coreutils, glibc, protobuf2_5, fuse, snappy, zlib, bzip2, openssl }:

let
  common = { version, sha256, dependencies-sha256, tomcat }:
    let
      # compile the hadoop tarball from sources, it requires some patches
      binary-distributon = stdenv.mkDerivation rec {
        name = "hadoop-${version}-bin";
        src = fetchurl {
          url = "mirror://apache/hadoop/common/hadoop-${version}/hadoop-${version}-src.tar.gz";
          inherit sha256;
        };

        postUnpack = stdenv.lib.optionalString (tomcat != null) ''
          install -D ${tomcat.src} $sourceRoot/hadoop-hdfs-project/hadoop-hdfs-httpfs/downloads/apache-tomcat-${tomcat.version}.tar.gz
          install -D ${tomcat.src} $sourceRoot/hadoop-common-project/hadoop-kms/downloads/apache-tomcat-${tomcat.version}.tar.gz
        '';

        # perform fake build to make a fixed-output derivation of dependencies downloaded from maven central (~100Mb in ~3000 files)
        fetched-maven-deps = stdenv.mkDerivation {
          name = "hadoop-${version}-maven-deps";
          inherit src postUnpack nativeBuildInputs buildInputs configurePhase;
          buildPhase = ''
            while mvn package -Dmaven.repo.local=$out/.m2 ${mavenFlags} -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
              echo "timeout, restart maven to continue downloading"
            done
          '';
          # keep only *.{pom,jar,xml,sha1,so,dll,dylib} and delete all ephemeral files with lastModified timestamps inside
          installPhase = ''find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete'';
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
          outputHash = dependencies-sha256;
        };

        nativeBuildInputs = [ maven cmake pkgconfig ];
        buildInputs = [ fuse snappy zlib bzip2 openssl protobuf2_5 ];
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
        configurePhase = "true"; # do not trigger cmake hook
        mavenFlags = "-Drequire.snappy -Drequire.bzip2 -DskipTests -Pdist,native -e";
        buildPhase = ''
          # 'maven.repo.local' must be writable
          mvn package --offline -Dmaven.repo.local=$(cp -dpR ${fetched-maven-deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2 ${mavenFlags}
          # remove runtime dependency on $jdk/jre/lib/amd64/server/libjvm.so
          patchelf --set-rpath ${stdenv.lib.makeLibraryPath [glibc]} hadoop-dist/target/hadoop-${version}/lib/native/libhadoop.so.1.0.0
          patchelf --set-rpath ${stdenv.lib.makeLibraryPath [glibc]} hadoop-dist/target/hadoop-${version}/lib/native/libhdfs.so.0.0.0
        '';
        installPhase = "mv hadoop-dist/target/hadoop-${version} $out";
      };
    in
      stdenv.mkDerivation rec {
        name = "hadoop-${version}";

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
                --prefix PATH : "${stdenv.lib.makeBinPath [ which jre bash coreutils ]}" \
                --prefix JAVA_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ openssl snappy zlib bzip2 ]}" \
                --set JAVA_HOME "${jre}" \
                --set HADOOP_PREFIX "$out"
            fi
          done
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
    sha256 = "1ahv67f3lwak3kbjvnk1gncq56z6dksbajj872iqd0awdsj3p5rf";
    dependencies-sha256 = "1lsr9nvrynzspxqcamb10d596zlnmnfpxhkd884gdiva0frm0b1r";
    tomcat = tomcat_6_0_48;
  };
  hadoop_2_8 = common {
    version = "2.8.4";
    sha256 = "16c3ljhrzibkjn3y1bmjxdgf0kn60l23ay5hqpp7vpbnqx52x68w";
    dependencies-sha256 = "1j4f461487fydgr5978nnm245ksv4xbvskfr8pbmfhcyss6b7w03";
    tomcat = tomcat_6_0_48;
  };
  hadoop_2_9 = common {
    version = "2.9.1";
    sha256 = "0qgmpfbpv7f521fkjy5ldzdb4lwiblhs0hyl8qy041ws17y5x7d7";
    dependencies-sha256 = "1d5i8jj5y746rrqb9lscycnd7acmxlkz64ydsiyqsh5cdqgy2x7x";
    tomcat = tomcat_6_0_48;
  };
  hadoop_3_0 = common {
    version = "3.0.3";
    sha256 = "1vvkci0kx4b48dg0niifn2d3r4wwq8pb3c5z20wy8pqsqrqhlci5";
    dependencies-sha256 = "1kzkna9ywacm2m1cirj9cyip66bgqjhid2xf9rrhq6g10lhr8j9m";
    tomcat = null;
  };
  hadoop_3_1 = common {
    version = "3.1.1";
    sha256 = "04hhdbyd4x1hy0fpy537f8mi0864hww97zap29x7dk1smrffwabd";
    dependencies-sha256 = "1q63jsxg3d31x0p8hvhpvbly2b07almyzsbhwphbczl3fhlqgiwn";
    tomcat = null;
  };
}
