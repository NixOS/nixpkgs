{ lib, stdenv, fetchurl, makeWrapper, hadoop, jre, bash }:

stdenv.mkDerivation rec {
  pname = "pig";
  version = "0.17.0";

  src = fetchurl {
    url = "mirror://apache/pig/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1wwpg0w47f49rnivn2d26vrxgyfl9gpqx3vmzbl5lhx6x5l3fqbd";

  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    mv * $out

    # no need for the windows batch script
    rm $out/bin/pig.cmd $out/bin/pig.py

    for n in $out/{bin,sbin}"/"*; do
      wrapProgram $n \
        --prefix PATH : "${lib.makeBinPath [ jre bash ]}" \
        --set JAVA_HOME "${jre}" --set HADOOP_PREFIX "${hadoop}"
    done
  '';

  meta = with lib; {
    homepage = "https://pig.apache.org/";
    description = "High-level language for Apache Hadoop";
    mainProgram = "pig";
    license = licenses.asl20;

    longDescription = ''
      Apache Pig is a platform for analyzing large data sets that consists of a
      high-level language for expressing data analysis programs, coupled with
      infrastructure for evaluating these programs. The salient property of Pig
      programs is that their structure is amenable to substantial parallelization,
      which in turns enables them to handle very large data sets.
    '';

    platforms = platforms.linux;
    maintainers = [ ];
  };
}
