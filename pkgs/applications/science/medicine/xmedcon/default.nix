{ stdenv
, lib
, fetchurl
, gtk3
, glib
, pkg-config
, libpng
, zlib
<<<<<<< HEAD
, wrapGAppsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "xmedcon";
  version = "0.23.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-g1CRJDokLDzB+1YIuVQNByBLx01CI47EwGeluqVDujk=";
  };

  buildInputs = [
    gtk3
    glib
    libpng
    zlib
  ];

<<<<<<< HEAD
  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  meta = with lib; {
    description = "An open source toolkit for medical image conversion ";
    homepage = "https://xmedcon.sourceforge.net/";
=======
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "An open source toolkit for medical image conversion ";
    homepage = "https://xmedcon.sourceforge.io/Main/HomePage";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ arianvp flokli ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
