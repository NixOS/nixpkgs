{ stdenv, fetchurl, makeWrapper, which, jre, bash }:

stdenv.mkDerivation rec {

  name = "hadoop-2.0.1-alpha";

  src = fetchurl {
    url = "mirror://apache/hadoop/common/${name}/${name}.tar.gz";
    sha256 = "4e5f4fa1574ee58fd6d59a220b66578fc2cf62c229120eeed07f2880c86f0e59";
  };

  buildInputs = [ makeWrapper ];

  buildPhase = ''
    for n in "bin/"* "sbin/"*; do
      sed -i $n -e "s|#!/usr/bin/env bash|#! ${bash}/bin/bash|"
    done
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" bin/container-executor
  '';

  installPhase = ''
    mkdir -p $out
    mv *.txt share/doc/hadoop/
    mv * $out

    for n in $out/{bin,sbin}"/"*; do
      wrapProgram $n --prefix PATH : "${which}/bin:${jre}/bin:${bash}/bin" --set JAVA_HOME "${jre}" --set HADOOP_PREFIX "$out"
    done
  '';

  meta = {
    homepage = "http://hadoop.apache.org/";
    description = "framework for distributed processing of large data sets across clusters of computers";
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
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
