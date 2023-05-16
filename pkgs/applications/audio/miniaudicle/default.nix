{ lib
, stdenv
<<<<<<< HEAD
, fetchFromGitHub
, qmake
, wrapQtAppsHook
, qscintilla-qt6
=======
, fetchurl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, bison
, flex
, which
, alsa-lib
, libsndfile
<<<<<<< HEAD
=======
, qt4
, qscintilla-qt4
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libpulseaudio
, libjack2
, audioBackend ? "pulse" # "pulse", "alsa", or "jack"
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "miniaudicle";
  version = "1.5.0.7";

  src = fetchFromGitHub {
    owner = "ccrma";
    repo = "miniAudicle";
    rev = "chuck-${finalAttrs.version}";
    hash = "sha256-CqsajNLcOp7CS5RsVabWM6APnNh4alSKb2/eoZ7F4Ao=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    echo '#define GIT_REVISION "${finalAttrs.version}-NixOS"' > git-rev.h
=======
stdenv.mkDerivation rec {
  pname = "miniaudicle";
  version = "1.3.5.2";

  src = fetchurl {
    url = "https://audicle.cs.princeton.edu/mini/release/files/miniAudicle-${version}.tgz";
    hash = "sha256-dakDz69uHbKZFj8z67CubmRXEQ5X6GuYqlCXXvLzqSI=";
  };

  sourceRoot = "miniAudicle-${version}/src";

  postPatch = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    substituteInPlace miniAudicle.pro \
      --replace "/usr/local" $out
  '';

  nativeBuildInputs = [
    bison
    flex
    which
<<<<<<< HEAD
    qmake
    wrapQtAppsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    alsa-lib
    libsndfile
<<<<<<< HEAD
    qscintilla-qt6
=======
    qt4
    qscintilla-qt4
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optional (audioBackend == "pulse") libpulseaudio
    ++ lib.optional (audioBackend == "jack")  libjack2;

  buildFlags = [ "linux-${audioBackend}" ];

<<<<<<< HEAD
=======
  makeFlags = [ "PREFIX=$(out)" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A light-weight integrated development environment for the ChucK digital audio programming language";
    homepage = "https://audicle.cs.princeton.edu/mini/";
    downloadPage = "https://audicle.cs.princeton.edu/mini/linux/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # not attempted
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
