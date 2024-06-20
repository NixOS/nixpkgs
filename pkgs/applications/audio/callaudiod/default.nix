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
  version = "0.1.9";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "mobian1";
    repo = pname;
    rev = version;
    sha256 = "sha256-OuWn1DA+4LmN1KwouiqW3kn6CMg8jhm0FiyAgMSi1GI=";
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
    maintainers = with maintainers; [ pacman99 ];
    platforms = platforms.linux;
  };
}
