{ stdenv, fetchurl, kdelibs, gettext, xf86_input_wacom }:

stdenv.mkDerivation rec {
  name = "wacomtablet-2.0";

  src = fetchurl {
    url = "http://kde-apps.org/CONTENT/content-files/114856-wacomtablet-2.0.tar.bz2";
    sha256 = "1vqdmkfl0awsjxl6p8bihz198hlc75d3zn7xwwryc674l76s25ax";
  };

  buildInputs = [ kdelibs xf86_input_wacom ];

  nativeBuildInputs = [ gettext ];

  meta = with stdenv.lib; {
    description = "KDE Wacom graphic tablet configuration tool";
    license = licenses.gpl2Plus;
    homepage = http://kde-apps.org/content/show.php/wacom+tablet?content=114856;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.urkud ];
  };
}
