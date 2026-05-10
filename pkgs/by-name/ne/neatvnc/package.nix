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

stdenv.mkDerivation (finalAttrs: {
  pname = "neatvnc";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "neatvnc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VStlTsfXbFxTnRGdK1y7MLtCzxbHzraw5GGph3sS/kI=";
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
    changelog = "https://github.com/any1/neatvnc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
