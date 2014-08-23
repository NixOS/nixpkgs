{ stdenv, fetchurl, kdelibs, gettext, xf86_input_wacom }:

stdenv.mkDerivation rec {
  name = "wacomtablet-2.0.2";

  src = fetchurl {
    url = "http://kde-apps.org/CONTENT/content-files/114856-wacomtablet-2.0.2.tar.xz";
    sha256 = "13k5f5xpka5cbgl24a3j9khqcmp96x1vhynn9v558ag6dg9ch2hw";
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
