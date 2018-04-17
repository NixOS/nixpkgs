{stdenv, fetchurl, jre, makeWrapper}:

stdenv.mkDerivation rec {
  name = "picard-tools-${version}";
  version = "2.18.1";

  src = fetchurl {
    url = "https://github.com/broadinstitute/picard/releases/download/${version}/picard.jar";
    sha256 = "0wcihlgaif79r0fa47kq77igxzq0lpyn74414v9n6k9rl5nj8x1a";
  };

  buildInputs = [ jre makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/libexec/picard
    cp $src $out/libexec/picard/picard.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/picard --add-flags "-jar $out/libexec/picard/picard.jar"
  '';

  meta = with stdenv.lib; {
    description = "Tools for high-throughput sequencing (HTS) data and formats such as SAM/BAM/CRAM and VCF.";
    license = licenses.mit;
    homepage = https://broadinstitute.github.io/picard/;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
  };
}
