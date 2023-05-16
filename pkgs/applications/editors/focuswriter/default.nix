<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, hunspell
, qtbase
, qtmultimedia
, qttools
, qt5compat
, qtwayland
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "focuswriter";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = "focuswriter";
    rev = "v${version}";
    hash = "sha256-6wvTlC/NCCcN2jpwqtoOsCln3ViY/vj7NpMsbYHBGiI=";
  };

  nativeBuildInputs = [ pkg-config cmake qttools wrapQtAppsHook ];
  buildInputs = [ hunspell qtbase qtmultimedia qt5compat qtwayland ];

=======
{ lib, fetchurl, pkg-config, qmake, qttools, hunspell, qtbase, qtmultimedia, mkDerivation }:

mkDerivation rec {
  pname = "focuswriter";
  version = "1.7.6";

  src = fetchurl {
    url = "https://gottcode.org/focuswriter/focuswriter-${version}-src.tar.bz2";
    sha256 = "0h85f6cs9zbxv118mjfxqfv41j19zkx2xq36mpnlmrlzkjj7dx9l";
  };

  nativeBuildInputs = [ pkg-config qmake qttools ];
  buildInputs = [ hunspell qtbase qtmultimedia ];

  qmakeFlags = [ "PREFIX=/" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with lib; {
    description = "Simple, distraction-free writing environment";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ madjar kashw2 ];
=======
    maintainers = with maintainers; [ madjar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
    homepage = "https://gottcode.org/focuswriter/";
  };
}
