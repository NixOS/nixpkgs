{ lib
, stdenv
, fetchurl
, makeWrapper
, autoPatchelfHook
, jdk8_headless
, jdk11_headless
, bash
, coreutils
, which
, bzip2
, cyrus_sasl
, protobuf
, snappy
, zlib
, zstd
, openssl
, glibc
, nixosTests
, sparkSupport ? true
, spark
}:

with lib;

assert elem stdenv.system [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

let
  common = { pname, platformAttrs, untarDir ? "${pname}-${version}", jdk, openssl ? null, nativeLibs ? [ ], libPatches ? "", tests }:
    stdenv.mkDerivation rec {
      inherit pname jdk libPatches untarDir openssl;
      version = platformAttrs.${stdenv.system}.version or (throw "Unsupported system: ${stdenv.system}");
      src = fetchurl {
        url = "mirror://apache/hadoop/common/hadoop-${version}/hadoop-${version}" + optionalString stdenv.isAarch64 "-aarch64" + ".tar.gz";
        inherit (platformAttrs.${stdenv.system}) hash;
      };
      doCheck = true;

      nativeBuildInputs = [ makeWrapper ]
        ++ optionals (stdenv.isLinux && (nativeLibs != [ ] || libPatches != "")) [ autoPatchelfHook ];
      buildInputs = [ openssl ] ++ nativeLibs;

      installPhase = ''
        mkdir -p $out/{lib/${untarDir}/conf,bin,lib}
        mv * $out/lib/${untarDir}
      '' + optionalString stdenv.isLinux ''
        # All versions need container-executor, but some versions can't use autoPatchelf because of broken SSL versions
        patchelf --set-interpreter ${glibc.out}/lib64/ld-linux-x86-64.so.2 $out/lib/${untarDir}/bin/container-executor
      '' + ''
        for n in $(find $out/lib/${untarDir}/bin -type f ! -name "*.*"); do
          makeWrapper "$n" "$out/bin/$(basename $n)"\
            --set-default JAVA_HOME ${jdk.home}\
            --set-default HADOOP_HOME $out/lib/${untarDir}\
            --run "test -d /etc/hadoop-conf && export HADOOP_CONF_DIR=\''${HADOOP_CONF_DIR-'/etc/hadoop-conf/'}"\
            --set-default HADOOP_CONF_DIR $out/lib/${untarDir}/etc/hadoop/\
            --prefix PATH : "${makeBinPath [ bash coreutils which]}"\
            --prefix JAVA_LIBRARY_PATH : "${makeLibraryPath buildInputs}"
        done
      '' + optionalString sparkSupport ''
        # Add the spark shuffle service jar to YARN
        cp ${spark.src}/yarn/spark-${spark.version}-yarn-shuffle.jar $out/lib/${untarDir}/share/hadoop/yarn/
      '' + libPatches;

      passthru = { inherit tests; };

      meta = recursiveUpdate {
        homepage = "https://hadoop.apache.org/";
        description = "Framework for distributed processing of large data sets across clusters of computers";
        license = licenses.asl20;
        sourceProvenance = with sourceTypes; [ binaryBytecode ];

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
        maintainers = with maintainers; [ illustris ];
        platforms = attrNames platformAttrs;
      } (attrByPath [ stdenv.system "meta" ] {} platformAttrs);
    };
in
{
  # Different version of hadoop support different java runtime versions
  # https://cwiki.apache.org/confluence/display/HADOOP/Hadoop+Java+Versions
  hadoop_3_3 = common rec {
    pname = "hadoop";
    platformAttrs = rec {
        x86_64-linux = {
          version = "3.3.4";
          hash = "sha256-akg9GgsSNJDr2N8/cbZOs58zP3i5XwkK61jkM8vCQW0=";
        };
        x86_64-darwin = x86_64-linux;
        aarch64-linux = {
          version = "3.3.1";
          hash = "sha256-v1Om2pk0wsgKBghRD2wgTSHJoKd3jkm1wPKAeDcKlgI=";
          meta.knownVulnerabilities = [ "CVE-2021-37404" "CVE-2021-33036" ];
        };
        aarch64-darwin = aarch64-linux;
    };
    untarDir = "${pname}-${platformAttrs.${stdenv.system}.version}";
    jdk = jdk11_headless;
    inherit openssl;
    # TODO: Package and add Intel Storage Acceleration Library
    nativeLibs = [ stdenv.cc.cc.lib protobuf zlib snappy ];
    libPatches = ''
      ln -s ${getLib cyrus_sasl}/lib/libsasl2.so $out/lib/${untarDir}/lib/native/libsasl2.so.2
      ln -s ${getLib openssl}/lib/libcrypto.so $out/lib/${untarDir}/lib/native/
      ln -s ${getLib zlib}/lib/libz.so.1 $out/lib/${untarDir}/lib/native/
      ln -s ${getLib zstd}/lib/libzstd.so.1 $out/lib/${untarDir}/lib/native/
      ln -s ${getLib bzip2}/lib/libbz2.so.1 $out/lib/${untarDir}/lib/native/
    '' + optionalString stdenv.isLinux ''
      # libjvm.so for Java >=11
      patchelf --add-rpath ${jdk.home}/lib/server $out/lib/${untarDir}/lib/native/libnativetask.so.1.0.0
      # Java 8 has libjvm.so at a different path
      patchelf --add-rpath ${jdk.home}/jre/lib/amd64/server $out/lib/${untarDir}/lib/native/libnativetask.so.1.0.0
      # NixOS/nixpkgs#193370
      # This workaround is needed to use protobuf 3.19
      patchelf --replace-needed libprotobuf.so.18 libprotobuf.so $out/lib/${untarDir}/lib/native/libhdfspp.so
    '';
    tests = nixosTests.hadoop;
  };
  hadoop_3_2 = common rec {
    pname = "hadoop";
    platformAttrs.x86_64-linux = {
      version = "3.2.4";
      hash = "sha256-qt2gpMr+NHuiVR+/zFRzRyRKG725/ZNBIM69z9J9wNw=";
    };
    jdk = jdk8_headless;
    # not using native libs because of broken openssl_1_0_2 dependency
    # can be manually overridden
    tests = nixosTests.hadoop_3_2;
  };
  hadoop2 = common rec {
    pname = "hadoop";
    platformAttrs.x86_64-linux = {
      version = "2.10.2";
      hash = "sha256-xhA4zxqIRGNhIeBnJO9dLKf/gx/Bq+uIyyZwsIafEyo=";
    };
    jdk = jdk8_headless;
    tests = nixosTests.hadoop2;
  };
}
