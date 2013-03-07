{ stdenv, fetchurl, kdelibs, gettext }:

stdenv.mkDerivation rec {
  name = "wacomtablet-1.3.5";

  src = fetchurl {
    url = "http://kde-apps.org/CONTENT/content-files/114856-wacomtablet-v1.3.5.tar.bz2";
    sha256 = "0dgsp3izx2v44f6j8mhxc6zybjn5sj9038w6b4v2fgix47fri0ja";
  };

  buildInputs = [ kdelibs ];

  nativeBuildInputs = [ gettext ];

  meta = with stdenv.lib; {
    description = "KDE Wacom graphic tablet configuration tool";
    license = licenses.gpl2Plus;
    homepage = http://kde-apps.org/content/show.php/wacom+tablet?content=114856;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.urkud ];
  };
}
