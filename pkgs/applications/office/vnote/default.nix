{ lib
<<<<<<< HEAD
, stdenv
=======
, mkDerivation
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, qmake
, qtbase
, qtwebengine
<<<<<<< HEAD
, qtx11extras
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vnote";
  version = "3.17.0";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = "vnote";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-NUVu6tKXrrwAoT4BgxX05mmGSC9yx20lwvXzd4y19Zs=";
=======
}:

mkDerivation rec {
  pname = "vnote";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-osJvoi7oyZupJ/bnqpm0TdZ5cMYEeOw9DHOIAzONKLg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    qmake
<<<<<<< HEAD
    wrapQtAppsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    qtbase
    qtwebengine
<<<<<<< HEAD
    qtx11extras
  ];

  meta = {
    homepage = "https://vnotex.github.io/vnote";
    description = "A pleasant note-taking platform";
    changelog = "https://github.com/vnotex/vnote/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
=======
  ];

  meta = with lib; {
    homepage = "https://vnotex.github.io/vnote";
    description = "A pleasant note-taking platform";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
