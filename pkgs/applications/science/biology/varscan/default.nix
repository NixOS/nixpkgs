{stdenv, fetchurl, jre, makeWrapper}:

stdenv.mkDerivation rec {
  name = "varscan-${version}";
  version = "2.4.2";

  src = fetchurl {
    url = "https://github.com/dkoboldt/varscan/releases/download/${version}/VarScan.v${version}.jar";
    sha256 = "0cfhshinyqgwc6i7zf8lhbfybyly2x5anrz824zyvdhzz5i69zrl";
  };

  buildInputs = [ jre makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/libexec/varscan
    cp $src $out/libexec/varscan/varscan.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/varscan --add-flags "-jar $out/libexec/varscan/varscan.jar"
  '';

  meta = with stdenv.lib; {
    description = "Variant calling and somatic mutation/CNV detection for next-generation sequencing data";
    # VarScan 2 is free for non-commercial use by academic,
    # government, and non-profit/not-for-profit institutions. A
    # commercial version of the software is available, and licensed
    # through the Office of Technology Management at Washington
    # University School of Medicine.
    license = licenses.unfree;
    homepage = https://github.com/dkoboldt/varscan;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
  };

}
