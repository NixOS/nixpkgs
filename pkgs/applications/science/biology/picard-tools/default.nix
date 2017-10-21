{stdenv, fetchurl, jre, makeWrapper}:

stdenv.mkDerivation rec {
  name = "picard-tools-${version}";
  version = "2.7.1";

  src = fetchurl {
    url = "https://github.com/broadinstitute/picard/releases/download/${version}/picard.jar";
    sha256 = "0rcfcvy9zacqmh7nyqlm93hzsx6gfygmcf8d2p02h5l69gvygnb9";
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
