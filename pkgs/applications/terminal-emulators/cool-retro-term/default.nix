<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, mkDerivation
, qtbase
, qtquick1
, qmltermwidget
, qtquickcontrols2
, qtgraphicaleffects
, qmake
, nixosTests
}:

mkDerivation rec {
  version = "1.2.0";
=======
{ lib, stdenv, fetchFromGitHub, mkDerivation, qtbase, qtquick1, qmltermwidget
, qtquickcontrols, qtgraphicaleffects, qmake, nixosTests }:

mkDerivation rec {
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "cool-retro-term";

  src = fetchFromGitHub {
    owner = "Swordfish90";
    repo = "cool-retro-term";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-PewHLVmo+RTBHIQ/y2FBkgXsIvujYd7u56JdFC10B4c=";
=======
    rev = version;
    sha256 = "0mird4k88ml6y61hky2jynrjmnxl849fvhsr5jfdlnv0i7r5vwi5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patchPhase = ''
    sed -i -e '/qmltermwidget/d' cool-retro-term.pro
  '';

<<<<<<< HEAD
  buildInputs = [
    qtbase
    qtquick1
    qmltermwidget
    qtquickcontrols2
    qtgraphicaleffects
  ];

=======
  buildInputs = [ qtbase qtquick1 qmltermwidget qtquickcontrols qtgraphicaleffects ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ qmake ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  preFixup = ''
    mv $out/usr/share $out/share
    mv $out/usr/bin $out/bin
    rmdir $out/usr
  '' + lib.optionalString stdenv.isDarwin ''
    ln -s $out/bin/cool-retro-term.app/Contents/MacOS/cool-retro-term $out/bin/cool-retro-term
  '';

  passthru.tests.test = nixosTests.terminal-emulators.cool-retro-term;

  meta = {
    description = "Terminal emulator which mimics the old cathode display";
    longDescription = ''
      cool-retro-term is a terminal emulator which tries to mimic the look and
      feel of the old cathode tube screens. It has been designed to be
      eye-candy, customizable, and reasonably lightweight.
    '';
    homepage = "https://github.com/Swordfish90/cool-retro-term";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ skeidel ];
  };
}
