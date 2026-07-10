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
  libdrm,
  libjpeg_turbo,
  libgbm,
  nettle,
  pixman,
  zlib,
  python3,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neatvnc";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "neatvnc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yEWNiazRxc8G7ToqOcTtCXEuBCgXO64v31Xx1YeOPCM=";
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
    libdrm
    libjpeg_turbo
    libgbm
    nettle
    pixman
    zlib
  ];

  nativeCheckInputs = [
    python3
    openssl
  ];

  mesonFlags = [
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  __structuredAttrs = true;

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
