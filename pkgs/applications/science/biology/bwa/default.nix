{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "bwa-${version}";
  version = "0.7.15";

  src = fetchurl {
    url = "https://github.com/lh3/bwa/releases/download/v0.7.15/bwa-0.7.15.tar.bz2";
    sha256 = "0585ikg0gv0mpyw9iq0bq9n0hr95867bbv8jbzs9pk4slkpsymig";
  };

  buildInputs = [ zlib ];
  installPhase = ''
    mkdir -p $out/bin
    cp bwa $out/bin
    '';

  meta = with stdenv.lib; {
    description = "A software package for mapping low-divergent sequences against a large reference genome, such as the human genome";
    license = licenses.gpl3;
    homepage = http://bio-bwa.sourceforge.net/;
    maintainers = with maintainers; [ luispedro ];
  };
}
