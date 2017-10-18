{ stdenv, fetchurl, makeWrapper, which, jre, bash }:

stdenv.mkDerivation rec {

  name = "hadoop-2.8.1";

  src = fetchurl {
    url = "mirror://apache/hadoop/common/${name}/${name}.tar.gz";
    sha256 = "1nbppl1jf24jsxxmkgzp0kbwl950f6pb8nj3rmjqab7gg1sm5gmm";
  };

  buildInputs = [ makeWrapper ];

  buildPhase = ''
    for n in "bin/"* "sbin/"*; do
      sed -i $n -e "s|#!/usr/bin/env bash|#! ${bash}/bin/bash|"
    done
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" bin/container-executor;
  '';

  installPhase = ''
    mkdir -p $out
    mv *.txt share/doc/hadoop/
    mv * $out

    for n in $out/{bin,sbin}"/"*; do
      wrapProgram $n --prefix PATH : "${stdenv.lib.makeBinPath [ which jre bash ]}" --set JAVA_HOME "${jre}" --set HADOOP_PREFIX "$out"
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
}
