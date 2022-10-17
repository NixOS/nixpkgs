{lib, stdenv, fetchurl, jre, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "picard-tools";
  version = "2.27.4";

  src = fetchurl {
    url = "https://github.com/broadinstitute/picard/releases/download/${version}/picard.jar";
    sha256 = "sha256-H52iduXuZXkH7i+1qGq05DTPgLGZD2ke6US5nTzmvDg=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/libexec/picard
    cp $src $out/libexec/picard/picard.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/picard --add-flags "-jar $out/libexec/picard/picard.jar"
  '';

  meta = with lib; {
    description = "Tools for high-throughput sequencing (HTS) data and formats such as SAM/BAM/CRAM and VCF";
    license = licenses.mit;
    homepage = "https://broadinstitute.github.io/picard/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ jbedo ];
    mainProgram = "picard";
    platforms = platforms.all;
  };
}
