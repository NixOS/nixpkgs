{ lib, stdenv, fetchurl, makeWrapper, autoPatchelfHook
, jdk8_headless, jdk11_headless
, bash, coreutils, which
, bzip2, cyrus_sasl , protobuf3_7, snappy, zlib, zstd
, openssl
}:

with lib;

let
  common = { pname, version, untarDir ? "${pname}-${version}", sha256, jdk, openssl, nativeLibs ? [ ], libPatches ? "" }:
    stdenv.mkDerivation rec {
      inherit pname version jdk libPatches untarDir openssl;
      src = fetchurl {
        url = "mirror://apache/hadoop/common/hadoop-${version}/hadoop-${version}.tar.gz";
        inherit sha256;
      };

      nativeBuildInputs = [ makeWrapper ]
        ++ optional (nativeLibs != [] || libPatches != "") [ autoPatchelfHook ];
      buildInputs = [ openssl ] ++ nativeLibs;

      installPhase = ''
        mkdir -p $out/{lib/${untarDir}/conf,bin,lib}
        mv * $out/lib/${untarDir}

        for n in $(find $out/lib/${untarDir}/bin -type f ! -name "*.*"); do
          makeWrapper "$n" "$out/bin/$(basename $n)"\
            --set-default JAVA_HOME ${jdk.home}\
            --set-default HADOOP_HOME $out/lib/${untarDir}\
            --set-default HADOOP_CONF_DIR /etc/hadoop-conf/\
            --prefix PATH : "${makeBinPath [ bash coreutils which]}"\
            --prefix JAVA_LIBRARY_PATH : "${makeLibraryPath buildInputs}"
        done
      '' + libPatches;

      meta = {
        homepage = "https://hadoop.apache.org/";
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
        maintainers = with maintainers; [ volth illustris ];
        platforms = [ "x86_64-linux" ];
      };

    };
in
{
  # Different version of hadoop support different java runtime versions
  # https://cwiki.apache.org/confluence/display/HADOOP/Hadoop+Java+Versions
  hadoop_3_3 = common rec {
    pname = "hadoop";
    version = "3.3.1";
    sha256 = "1b3v16ihysqaxw8za1r5jlnphy8dwhivdx2d0z64309w57ihlxxd";
    untarDir = "${pname}-${version}";
    jdk = jdk11_headless;
    inherit openssl;
    # TODO: Package and add Intel Storage Acceleration Library
    nativeLibs = [ stdenv.cc.cc.lib protobuf3_7 zlib snappy ];
    libPatches = ''
      ln -s ${getLib cyrus_sasl}/lib/libsasl2.so $out/lib/${untarDir}/lib/native/libsasl2.so.2
      ln -s ${getLib openssl}/lib/libcrypto.so $out/lib/${untarDir}/lib/native/
      ln -s ${getLib zlib}/lib/libz.so.1 $out/lib/${untarDir}/lib/native/
      ln -s ${getLib zstd}/lib/libzstd.so.1 $out/lib/${untarDir}/lib/native/
      ln -s ${getLib bzip2}/lib/libbz2.so.1 $out/lib/${untarDir}/lib/native/
      patchelf --add-rpath ${jdk.home}/lib/server $out/lib/${untarDir}/lib/native/libnativetask.so.1.0.0
    '';
  };
  hadoop_3_2 = common rec {
    pname = "hadoop";
    version = "3.2.2";
    sha256 = "1hxq297cqvkfgz2yfdiwa3l28g44i2abv5921k2d6b4pqd33prwp";
    jdk = jdk8_headless;
    # not using native libs because of broken openssl_1_0_2 dependency
    # can be manually overriden
    openssl = null;
  };
  hadoop2 = common rec {
    pname = "hadoop";
    version = "2.10.1";
    sha256 = "1w31x4bk9f2swnx8qxx0cgwfg8vbpm6cy5lvfnbbpl3rsjhmyg97";
    jdk = jdk8_headless;
    openssl = null;
  };
}
