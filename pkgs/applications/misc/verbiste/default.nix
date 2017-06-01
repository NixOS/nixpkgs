{ stdenv, fetchurl, pkgconfig, libgnomeui, libxml2 }:

stdenv.mkDerivation rec {
  name = "verbiste-${version}";

  version = "0.1.44";

  src = fetchurl {
    url = "http://perso.b2b2c.ca/~sarrazip/dev/${name}.tar.gz";
    sha256 = "0vmjr8w3qc64y312a0sj0ask309mmmlmyxp2fsii0ji35ls7m9sw";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libgnomeui libxml2 ];

  meta = with stdenv.lib; {
    homepage = http://sarrazip.com/dev/verbiste.html;
    description = "French and Italian verb conjugator";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
