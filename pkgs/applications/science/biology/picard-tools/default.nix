{stdenv, fetchurl, jre, makeWrapper}:

stdenv.mkDerivation rec {
  name = "picard-tools-${version}";
  version = "2.18.27";

  src = fetchurl {
    url = "https://github.com/broadinstitute/picard/releases/download/${version}/picard.jar";
    sha256 = "1pc9mhp35n0dl7j06c1564b797v6iqg6vhmd2xxvysc96hnsbyvc";
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
