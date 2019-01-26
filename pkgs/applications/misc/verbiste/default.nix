{ stdenv, fetchurl, pkgconfig, libgnomeui, libxml2 }:

stdenv.mkDerivation rec {
  name = "verbiste-${version}";

  version = "0.1.45";

  src = fetchurl {
    url = "https://perso.b2b2c.ca/~sarrazip/dev/${name}.tar.gz";
    sha256 = "180zyhdjspp7lk2291wsqs6bm7y27r7bd00447iimmjpx372s22c";
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
