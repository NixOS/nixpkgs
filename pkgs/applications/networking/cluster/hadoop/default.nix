{ stdenv, fetchurl, makeWrapper, which, jre, bash }:

let 
  hadoopDerivation = { version, sha256 }: stdenv.mkDerivation rec {

    name = "hadoop-${version}";

    src = fetchurl {
      url = "mirror://apache/hadoop/common/${name}/${name}.tar.gz";
      sha256 = "${sha256}";
    };

    buildInputs = [ makeWrapper ];

    buildPhase = ''
      for n in bin/{hadoop,hdfs,mapred,yarn} sbin/*.sh; do
      sed -i $n -e "s|#!/usr/bin/env bash|#! ${bash}/bin/bash|"
      done
    '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" bin/container-executor;
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" bin/test-container-executor;
    '';

    installPhase = ''
      mkdir -p $out
      mv *.txt share/doc/hadoop/
      mv * $out

      for n in $out/bin/{hadoop,hdfs,mapred,yarn} $out/sbin/*.sh; do
      wrapProgram $n --prefix PATH : "${stdenv.lib.makeBinPath [ which jre bash ]}" --set JAVA_HOME "${jre}" --set HADOOP_HOME "$out"
      done
    '';

    meta = {
      homepage = http://hadoop.apache.org/;
      description = "Framework for distributed processing of large data sets across clusters of computers";
      license = stdenv.lib.licenses.asl20;

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

      platforms = stdenv.lib.platforms.linux;
    };
  };
in
{
  hadoop_2_7 = hadoopDerivation {
    version = "2.7.6";
    sha256 = "0sanwam0k2m40pfsf9l5zxvklv8rvq78xvhd2pbsbiab7ylpwcpj";
  };
  hadoop_2_8 = hadoopDerivation {
    version = "2.8.4";
    sha256 = "05dik4qnazhf5aldwkljf610cwncsg5y3hyvgj476cfpzmr5jm3b";
  };
  hadoop_2_9 = hadoopDerivation {
    version = "2.9.1";
    sha256 = "1z22v46mmq9hfjc229x61ws332sa1rvmib3v4jsd6i1n29d03mpf";
  };
  hadoop_3_0 = hadoopDerivation {
    version = "3.0.2";
    sha256 = "10ig3rrcaizvs5bnni15fvm942mr5hfc2hr355g6ich722kpll0d";
  };
  hadoop_3_1 = hadoopDerivation { 
    version = "3.1.0";
    sha256 = "1rs3a752is1y2vgxjlqmmln00iwzncwlwg59l6gjv92zb7njq3b7";
  };
}
