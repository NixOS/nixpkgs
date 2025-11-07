{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  aml,
  ffmpeg,
  gnutls,
  libjpeg_turbo,
  libgbm,
  pixman,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "neatvnc";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "neatvnc";
    rev = "v${version}";
    hash = "sha256-wAIifLw2rlu44jXMu/k31B7qePdJt6pT6TOhNxcyfLw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    aml
    ffmpeg
    gnutls
    libjpeg_turbo
    libgbm
    pixman
    zlib
  ];

  mesonFlags = [
    (lib.mesonBool "tests" true)
  ];

  doCheck = true;

  meta = {
    description = "VNC server library";
    longDescription = ''
      This is a liberally licensed VNC server library that's intended to be
      fast and neat. Goals:
      - Speed
      - Clean interface
      - Interoperability with the Freedesktop.org ecosystem
    '';
    homepage = "https://github.com/any1/neatvnc";
    changelog = "https://github.com/any1/neatvnc/releases/tag/v${version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
