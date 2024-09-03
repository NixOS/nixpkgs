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

assert lib.elem stdenv.system [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

let
  common = { pname, platformAttrs, jdk, tests }:
    stdenv.mkDerivation (finalAttrs: {
      inherit pname jdk;
      version = platformAttrs.${stdenv.system}.version or (throw "Unsupported system: ${stdenv.system}");
      src = fetchurl {
        url = "mirror://apache/hadoop/common/hadoop-${finalAttrs.version}/hadoop-${finalAttrs.version}"
              + lib.optionalString stdenv.isAarch64 "-aarch64" + ".tar.gz";
        inherit (platformAttrs.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) hash;
      };
      doCheck = true;

      # Build the container executor binary from source
      # InstallPhase is not lazily evaluating containerExecutor for some reason
      containerExecutor = if stdenv.isLinux then (callPackage ./containerExecutor.nix {
        inherit (finalAttrs) version;
        inherit platformAttrs;
      }) else "";

      nativeBuildInputs = [ makeWrapper ]
                          ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];
      buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib openssl protobuf zlib snappy libtirpc ];

      installPhase = ''
        mkdir $out
        mv * $out/
      '' + lib.optionalString stdenv.isLinux ''
        for n in $(find ${finalAttrs.containerExecutor}/bin -type f); do
          ln -sf "$n" $out/bin
        done

        # these libraries are loaded at runtime by the JVM
        ln -s ${lib.getLib cyrus_sasl}/lib/libsasl2.so $out/lib/native/libsasl2.so.2
        ln -s ${lib.getLib openssl}/lib/libcrypto.so $out/lib/native/
        ln -s ${lib.getLib zlib}/lib/libz.so.1 $out/lib/native/
        ln -s ${lib.getLib zstd}/lib/libzstd.so.1 $out/lib/native/
        ln -s ${lib.getLib bzip2}/lib/libbz2.so.1 $out/lib/native/
        ln -s ${lib.getLib snappy}/lib/libsnappy.so.1 $out/lib/native/

        # libjvm.so is in different paths for java 8 and 11
        # libnativetask.so in hadooop 3 and libhdfs.so in hadoop 2 depend on it
        find $out/lib/native/ -name 'libnativetask.so*' -o -name 'libhdfs.so*' | \
          xargs -n1 patchelf --add-rpath $(dirname $(find ${finalAttrs.jdk.home} -name libjvm.so | head -n1))

        # NixOS/nixpkgs#193370
        # This workaround is needed to use protobuf 3.19
        # hadoop 3.3+ depends on protobuf 3.18, 3.2 depends on 3.8
        find $out/lib/native -name 'libhdfspp.so*' | \
          xargs -r -n1 patchelf --replace-needed libprotobuf.so.${
            if (lib.versionAtLeast finalAttrs.version "3.3") then "18"
            else "8"
          } libprotobuf.so

        patchelf --replace-needed libcrypto.so.1.1 libcrypto.so \
          $out/lib/native/{libhdfs{pp,}.so*,examples/{pipes-sort,wordcount-nopipe,wordcount-part,wordcount-simple}}

      '' + ''
        for n in $(find $out/bin -type f ! -name "*.*"); do
          wrapProgram "$n"\
            --set-default JAVA_HOME ${finalAttrs.jdk.home}\
            --set-default HADOOP_HOME $out/\
            --run "test -d /etc/hadoop-conf && export HADOOP_CONF_DIR=\''${HADOOP_CONF_DIR-'/etc/hadoop-conf/'}"\
            --set-default HADOOP_CONF_DIR $out/etc/hadoop/\
            --prefix PATH : "${lib.makeBinPath [ bash coreutils which]}"\
            --prefix JAVA_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
        done
      '' + (lib.optionalString sparkSupport ''
        # Add the spark shuffle service jar to YARN
        cp ${spark.src}/yarn/spark-${spark.version}-yarn-shuffle.jar $out/share/hadoop/yarn/
      '');

      passthru = { inherit tests; };

      meta = with lib; recursiveUpdate {
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
  hadoop_3_4 = common rec {
    pname = "hadoop";
    platformAttrs = rec {
      x86_64-linux = {
        version = "3.4.0";
        hash = "sha256-4xGnhIBBQDD57GNUml1oXmnibyBxA9mr8hpIud0DyGw=";
        srcHash = "sha256-viDF3LdRCZHqFycOYfN7nUQBPHiMCIjmu7jgIAaaK9E=";
      };
      x86_64-darwin = x86_64-linux;
      aarch64-linux = x86_64-linux // {
        hash = "sha256-QWxzKtNyw/AzcHMv0v7kj91pw1HO7VAN9MHO84caFk8=";
      };
      aarch64-darwin = aarch64-linux;
    };
    jdk = jdk11_headless;
    # TODO: Package and add Intel Storage Acceleration Library
    tests = nixosTests.hadoop;
  };
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
    jdk = jdk11_headless;
    # TODO: Package and add Intel Storage Acceleration Library
    tests = nixosTests.hadoop_3_3;
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
