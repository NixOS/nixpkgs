{stdenv, fetchurl, jre, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "picard-tools";
  version = "2.21.6";

  src = fetchurl {
    url = "https://github.com/broadinstitute/picard/releases/download/${version}/picard.jar";
    sha256 = "1vpyzhrs3bbviwk2n7k5296rnsw7g9ksvjsibl0gm7dawip9jb5s";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/libexec/picard
    cp $src $out/libexec/picard/picard.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/picard --add-flags "-jar $out/libexec/picard/picard.jar"
  '';

  meta = with stdenv.lib; {
    description = "Tools for high-throughput sequencing (HTS) data and formats such as SAM/BAM/CRAM and VCF";
    license = licenses.mit;
    homepage = https://broadinstitute.github.io/picard/;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
  };
}
