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

stdenv.mkDerivation (finalAttrs: {
  pname = "callaudiod";
  version = "0.1.10";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "mobian1";
    repo = "callaudiod";
    tag = finalAttrs.version;
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

  meta = {
    description = "Daemon for dealing with audio routing during phone calls";
    homepage = "https://gitlab.com/mobian1/callaudiod";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pacman99 ];
    platforms = lib.platforms.linux;
  };
})
