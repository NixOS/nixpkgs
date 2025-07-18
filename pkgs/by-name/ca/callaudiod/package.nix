{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  alsa-lib,
  libpulseaudio,
}:

stdenv.mkDerivation rec {
  pname = "callaudiod";
  version = "0.1.10";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "mobian1";
    repo = "callaudiod";
    rev = version;
    hash = "sha256-gc66XrrFyhF1TvrDECBfGQc+MiDtqZPxdCn0S/43XQU=";
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
