{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  intltool,
  pkg-config,
  ffmpeg,
  wxGTK32,
  gtk3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spek";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "alexkay";
    repo = "spek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VYt2so2k3Rk3sLSV1Tf1G2pESYiXygrKr9Koop8ChCg=";
  };

  patches = [
    ./autoconf.patch
    # https://github.com/alexkay/spek/pull/338
    ./ffmpeg8-compat.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    ffmpeg
    wxGTK32
    gtk3
  ];

  meta = {
    description = "Analyse your audio files by showing their spectrogram";
    homepage = "https://www.spek.cc/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ bjornfor ];
    platforms = lib.platforms.all;
    mainProgram = "spek";
  };
})
