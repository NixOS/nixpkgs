<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtwebengine
, qttools
, wrapGAppsHook
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "rssguard";
  version = "4.5.0";
=======
{ lib, stdenv, fetchFromGitHub, cmake, qtwebengine, qttools, wrapGAppsHook, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "rssguard";
  version = "4.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    sha256 = "sha256-R3fw5GLQUYZUX1kH6e0IRQ/I/IsFTOK6aP5h5QVU0Ps=";
=======
    rev = version;
    sha256 = "sha256-1xoMymsx5Z8oZzZtPzLWaOs0zy/E0pIsLpHgZlVdgSw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs =  [ qtwebengine qttools ];
  nativeBuildInputs = [ cmake wrapGAppsHook wrapQtAppsHook ];
  qmakeFlags = [ "CONFIG+=release" ];

  meta = with lib; {
    description = "Simple RSS/Atom feed reader with online synchronization";
    longDescription = ''
      RSS Guard is a simple, light and easy-to-use RSS/ATOM feed aggregator
      developed using Qt framework and with online feed synchronization support
      for ownCloud/Nextcloud.
    '';
    homepage = "https://github.com/martinrotter/rssguard";
<<<<<<< HEAD
    changelog = "https://github.com/martinrotter/rssguard/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
