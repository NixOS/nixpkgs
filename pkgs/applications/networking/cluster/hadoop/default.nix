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
, libtirpc
, callPackage
}:

with lib;

assert elem stdenv.system [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

let
  common = { pname, platformAttrs, untarDir ? "${pname}-${version}", jdk, openssl ? null, nativeLibs ? [ ], libPatchesGenerator ? (_: ""), tests }:
    stdenv.mkDerivation (finalAttrs: {
      inherit pname jdk untarDir openssl;
      libPatches = libPatchesGenerator finalAttrs;
      version = platformAttrs.${stdenv.system}.version or (throw "Unsupported system: ${stdenv.system}");
      src = fetchurl {
        url = "mirror://apache/hadoop/common/hadoop-${finalAttrs.version}/hadoop-${finalAttrs.version}" + optionalString stdenv.isAarch64 "-aarch64" + ".tar.gz";
        inherit (platformAttrs.${stdenv.system}) hash;
      };
      doCheck = true;

      # Build the container executor binary from source
      containerExecutor = callPackage ./containerExecutor.nix {
        inherit (finalAttrs) version;
        inherit platformAttrs;
        hash = platformAttrs.${stdenv.system}.srcHash;
      };

      nativeBuildInputs = [ makeWrapper ]
                          ++ optionals (stdenv.isLinux && (nativeLibs != [ ] || (libPatches finalAttrs) != "")) [ autoPatchelfHook ];
      buildInputs = [ openssl ] ++ nativeLibs;

      installPhase = ''
        mkdir -p $out/{lib/${finalAttrs.untarDir}/conf,bin,lib}
        mv * $out/lib/${finalAttrs.untarDir}
      '' + optionalString stdenv.isLinux ''
        for n in $(find ${finalAttrs.containerExecutor}/bin -type f); do
          ln -sf "$n" $out/lib/${finalAttrs.untarDir}/bin
        done
      '' + ''
        for n in $(find $out/lib/${finalAttrs.untarDir}/bin -type f ! -name "*.*"); do
          makeWrapper "$n" "$out/bin/$(basename $n)"\
            --set-default JAVA_HOME ${finalAttrs.jdk.home}\
            --set-default HADOOP_HOME $out/lib/${finalAttrs.untarDir}\
            --run "test -d /etc/hadoop-conf && export HADOOP_CONF_DIR=\''${HADOOP_CONF_DIR-'/etc/hadoop-conf/'}"\
            --set-default HADOOP_CONF_DIR $out/lib/${finalAttrs.untarDir}/etc/hadoop/\
            --prefix PATH : "${makeBinPath [ bash coreutils which]}"\
            --prefix JAVA_LIBRARY_PATH : "${makeLibraryPath finalAttrs.buildInputs}"
        done
      '' + optionalString sparkSupport ''
        # Add the spark shuffle service jar to YARN
        cp ${spark.src}/yarn/spark-${spark.version}-yarn-shuffle.jar $out/lib/${finalAttrs.untarDir}/share/hadoop/yarn/
      '' + (finalAttrs.libPatches);

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
    });
in
{
  # Different version of hadoop support different java runtime versions
  # https://cwiki.apache.org/confluence/display/HADOOP/Hadoop+Java+Versions
  hadoop_3_3 = common rec {
    pname = "hadoop";
    platformAttrs = rec {
      x86_64-linux = {
        version = "3.3.6";
        hash = "sha256-9RlQWcDUECrap//xf3sqhd+Qa8tuGZSHFjGfmXhkGgQ=";
        srcHash = "sha256-4OEsVhBNV9CJ+PN4FgCduUCVA9/el5yezSCZ6ko3+bU=";
      };
      x86_64-darwin = x86_64-linux;
      aarch64-linux = x86_64-linux // {
        hash = "sha256-5Lv2uA72BJEva5v2yncyPe5gKNCNOPNsoHffVt6KXQ0=";
      };
      aarch64-darwin = aarch64-linux;
    };
    untarDir = "${pname}-${platformAttrs.${stdenv.system}.version}";
    jdk = jdk11_headless;
    inherit openssl;
    # TODO: Package and add Intel Storage Acceleration Library
    nativeLibs = [ stdenv.cc.cc.lib protobuf zlib snappy libtirpc ];
    libPatchesGenerator = finalAttrs: (''
      ln -s ${getLib cyrus_sasl}/lib/libsasl2.so $out/lib/${finalAttrs.untarDir}/lib/native/libsasl2.so.2
      ln -s ${getLib openssl}/lib/libcrypto.so $out/lib/${finalAttrs.untarDir}/lib/native/
      ln -s ${getLib zlib}/lib/libz.so.1 $out/lib/${finalAttrs.untarDir}/lib/native/
      ln -s ${getLib zstd}/lib/libzstd.so.1 $out/lib/${finalAttrs.untarDir}/lib/native/
      ln -s ${getLib bzip2}/lib/libbz2.so.1 $out/lib/${finalAttrs.untarDir}/lib/native/
    '' + optionalString stdenv.isLinux ''
      # libjvm.so for Java >=11
      patchelf --add-rpath ${finalAttrs.jdk.home}/lib/server $out/lib/${finalAttrs.untarDir}/lib/native/libnativetask.so.1.0.0
      # Java 8 has libjvm.so at a different path
      patchelf --add-rpath ${finalAttrs.jdk.home}/jre/lib/amd64/server $out/lib/${finalAttrs.untarDir}/lib/native/libnativetask.so.1.0.0
      # NixOS/nixpkgs#193370
      # This workaround is needed to use protobuf 3.19
      patchelf --replace-needed libprotobuf.so.18 libprotobuf.so $out/lib/${finalAttrs.untarDir}/lib/native/libhdfspp.so
      patchelf --replace-needed libcrypto.so.1.1 libcrypto.so \
        $out/lib/${finalAttrs.untarDir}/lib/native/{libhdfspp.so.0.1.0,examples/{pipes-sort,wordcount-nopipe,wordcount-part,wordcount-simple}}
    '');
    tests = nixosTests.hadoop;
  };
  hadoop_3_2 = common rec {
    pname = "hadoop";
    platformAttrs.x86_64-linux = {
      version = "3.2.4";
      hash = "sha256-qt2gpMr+NHuiVR+/zFRzRyRKG725/ZNBIM69z9J9wNw=";
      srcHash = "sha256-F9nGD3mZZ1eJf3Ec3AJGE9YBcL/HiagskcdKQhCn/sw=";
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
      srcHash = "sha256-ucxCyXiJo8aL6aNMhZgKEbn8sGKOoMPVREbMGSfSdAI=";
    };
    jdk = jdk8_headless;
    tests = nixosTests.hadoop2;
  };
}
