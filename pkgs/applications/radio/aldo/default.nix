{ stdenv, fetchurl, libao }:

stdenv.mkDerivation rec {
  pname = "aldo";
  version = "0.7.7";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "14lzgldqzbbzydsy1cai3wln3hpyj1yhj8ji3wygyzr616fq9f7i";
  };

  buildInputs = [ libao ];

  meta = with stdenv.lib; {
    description = "Morse code training program";
    homepage = http://aldo.nongnu.org/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
