{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "picard-tools";
  version = "3.4.0";

  src = fetchurl {
    url = "https://github.com/broadinstitute/picard/releases/download/${finalAttrs.version}/picard.jar";
    sha256 = "sha256-52EowoOIn8WDyd6jOjt0SJdMBn0QLJ41vhUmQtTV+QE=";
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

  meta = {
    description = "Tools for high-throughput sequencing (HTS) data and formats such as SAM/BAM/CRAM and VCF";
    license = lib.licenses.mit;
    homepage = "https://broadinstitute.github.io/picard/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ jbedo ];
    mainProgram = "picard";
    platforms = lib.platforms.all;
  };
})
