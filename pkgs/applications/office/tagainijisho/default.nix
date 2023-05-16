<<<<<<< HEAD
{ stdenv, lib, fetchzip, qtbase, qttools, cmake, sqlite, wrapQtAppsHook }:

stdenv.mkDerivation rec {
=======
{ lib, mkDerivation, fetchzip, qtbase, qttools, cmake, sqlite }:
mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "tagainijisho";
  version = "1.2.2";

  src = fetchzip {
    url = "https://github.com/Gnurou/tagainijisho/releases/download/${version}/tagainijisho-${version}.tar.gz";
    hash = "sha256-CTDMoYGbVE4W0SDerW//aAdUVsySWFQycSy0I3a9+94=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ qttools cmake wrapQtAppsHook ];
  buildInputs = [ qtbase sqlite ];
=======
  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase qttools sqlite ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cmakeFlags = [
    "-DEMBED_SQLITE=OFF"
  ];

  meta = with lib; {
    description = "A free, open-source Japanese dictionary and kanji lookup tool";
    homepage = "https://www.tagaini.net/";
    license = with licenses; [
      /* program */
      gpl3Plus
      /* data */
      cc-by-sa-30
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ vbgl ];
  };
}
