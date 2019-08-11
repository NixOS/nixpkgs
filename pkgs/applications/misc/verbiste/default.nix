{ stdenv, fetchurl, pkgconfig, libgnomeui, libxml2 }:

stdenv.mkDerivation rec {
  name = "verbiste-${version}";

  version = "0.1.46";

  src = fetchurl {
    url = "https://perso.b2b2c.ca/~sarrazip/dev/${name}.tar.gz";
    sha256 = "13l8b8mbkdds955sn42hzrjzj48lg1drpd7vhpcjxadckbvlh1p0";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libgnomeui libxml2 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://sarrazip.com/dev/verbiste.html;
    description = "French and Italian verb conjugator";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
