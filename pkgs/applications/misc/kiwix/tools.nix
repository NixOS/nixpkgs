{ lib
, fetchFromGitHub
<<<<<<< HEAD
, gitUpdater
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, icu
, libkiwix
, meson
, ninja
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "kiwix-tools";
<<<<<<< HEAD
  version = "3.5.0";
=======
  version = "3.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "kiwix-tools";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-bOxi51H28LhA+5caX6kllIY5B3Q1FoGVFadFIhYRkG0=";
=======
    sha256 = "sha256-r3/aTH/YoDuYpKLPakP4toS3OtiRueTUjmR34rdmr+w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    icu
    libkiwix
  ];

<<<<<<< HEAD
  passthru.updateScript = gitUpdater { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Command line Kiwix tools: kiwix-serve, kiwix-manage, ...";
    homepage = "https://kiwix.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colinsane ];
  };
}

