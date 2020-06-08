{stdenv, fetchurl, jre, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "picard-tools";
  version = "2.22.9";

  src = fetchurl {
    url = "https://github.com/broadinstitute/picard/releases/download/${version}/picard.jar";
    sha256 = "0qm32a58b2asiw8rnw1r6vz3bi61vfdan6wyr9f78fj4d07q7n53";
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
