{
  lib,
  alsa-lib,
  fetchFromGitLab,
  gitUpdater,
  glib,
  libpulseaudio,
  meson,
  ninja,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "callaudiod";
  version = "0.1.10";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "mobian1";
    repo = "callaudiod";
    rev = finalAttrs.version;
    hash = "sha256-gc66XrrFyhF1TvrDECBfGQc+MiDtqZPxdCn0S/43XQU=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libpulseaudio
    glib
  ];

  strictDeps = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    homepage = "https://gitlab.com/mobian1/callaudiod";
    description = "Daemon for dealing with audio routing during phone calls";
    license = lib.licenses.gpl3Plus;
    mainProgram = "callaudiocli";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (alsa-lib.meta) platforms;
  };
})
