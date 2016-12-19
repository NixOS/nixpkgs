{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, kdelibs, xf86_input_wacom }:

stdenv.mkDerivation rec {
  name = "wacomtablet-2.1.0";

  src = fetchurl {
    url = "http://kde-apps.org/CONTENT/content-files/114856-wacomtablet-2.1.0.tar.xz";
    sha256 = "17n1p5v2yx517hkqd13pyl3wnrdnh6pfzwf2y2csrfckyndhwk8w";
  };

  buildInputs = [ kdelibs xf86_input_wacom ];

  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig ];

  meta = with stdenv.lib; {
    description = "KDE Wacom graphic tablet configuration tool";
    license = licenses.gpl2Plus;
    homepage = http://kde-apps.org/content/show.php/wacom+tablet?content=114856;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.urkud ];
  };
}
