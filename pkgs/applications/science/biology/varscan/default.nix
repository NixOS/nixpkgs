{lib, stdenv, fetchurl, jre, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "varscan";
  version = "2.4.4";

  src = fetchurl {
    url = "https://github.com/dkoboldt/varscan/raw/master/VarScan.v${version}.jar";
    sha256 = "sha256-+yO3KrZ2+1qJvQIJHCtsmv8hC5a+4E2d7mrvTYtygU0=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/libexec/varscan
    cp $src $out/libexec/varscan/varscan.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/varscan --add-flags "-jar $out/libexec/varscan/varscan.jar"
  '';

  meta = with lib; {
    description = "Variant calling and somatic mutation/CNV detection for next-generation sequencing data";
    # VarScan 2 is free for non-commercial use by academic,
    # government, and non-profit/not-for-profit institutions. A
    # commercial version of the software is available, and licensed
    # through the Office of Technology Management at Washington
    # University School of Medicine.
    license = licenses.unfree;
    homepage = "https://github.com/dkoboldt/varscan";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
  };

}
