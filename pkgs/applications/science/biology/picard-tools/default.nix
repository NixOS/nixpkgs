{stdenv, fetchurl, jre, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "picard-tools";
  version = "2.23.3";

  src = fetchurl {
    url = "https://github.com/broadinstitute/picard/releases/download/${version}/picard.jar";
    sha256 = "08wgi0hijfbchr2srmndxq3h2fijvyvr8b6zv680fpcjixm5bbhf";
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
    homepage = "https://broadinstitute.github.io/picard/";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
  };
}
