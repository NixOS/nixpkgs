{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "bwa";
  version = "0.7.17";

  src = fetchurl {
    url = "mirror://sourceforge/bio-bwa/${pname}-${version}.tar.bz2";
    sha256 = "1zfhv2zg9v1icdlq4p9ssc8k01mca5d1bd87w71py2swfi74s6yy";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    install -vD bwa $out/bin/bwa
  '';

  meta = with stdenv.lib; {
    description = "A software package for mapping low-divergent sequences against a large reference genome, such as the human genome";
    license     = licenses.gpl3;
    homepage    = "http://bio-bwa.sourceforge.net/";
    maintainers = with maintainers; [ luispedro ];
    platforms = [ "x86_64-linux" ];
  };
}
