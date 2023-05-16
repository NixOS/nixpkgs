{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
, alsa-lib
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "callaudiod";
<<<<<<< HEAD
  version = "0.1.9";
=======
  version = "0.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "mobian1";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-OuWn1DA+4LmN1KwouiqW3kn6CMg8jhm0FiyAgMSi1GI=";
=======
    sha256 = "sha256-BDEu3ASlnovMK0lQC+CQvpXvtdt33BRntstPAWaAnsg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
  ];

  buildInputs = [
    alsa-lib
    libpulseaudio
    glib
  ];

  meta = with lib; {
    description = "Daemon for dealing with audio routing during phone calls";
    homepage = "https://gitlab.com/mobian1/callaudiod";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pacman99 tomfitzhenry ];
    platforms = platforms.linux;
  };
}
