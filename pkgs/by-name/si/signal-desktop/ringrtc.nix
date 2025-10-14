{
  rustPackages_1_89,
  lib,
  fetchFromGitHub,
  cmake,
  protobuf,
  webrtc,
  pkg-config,
  cubeb,
  libpulseaudio,
}:
let
  cubeb' = cubeb.override {
    alsaSupport = false;
    pulseSupport = true;
    jackSupport = false;
    sndioSupport = false;
    buildSharedLibs = false;
  };
in
rustPackages_1_89.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ringrtc";
  version = "2.58.1";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "ringrtc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HI+HVDv+nuJp2BPIAVY+PI6Pof1pnB8L6CIAgBT+tJA=";
  };

  cargoHash = "sha256-n+1pe202U2lljisSRBWeVvuBLyp7jhXG+ovDDi5WV8Q=";

  cargoBuildFlags = [
    "-p"
    "ringrtc"
    "--features"
    "electron"
  ];
  doCheck = false;

  env = {
    LIBCUBEB_SYS_USE_PKG_CONFIG = 1;
    LIBCUBEB_STATIC = 1;
  };

  nativeBuildInputs = [
    protobuf
    cmake
    pkg-config
  ];
  buildInputs = [
    webrtc
    cubeb'
    libpulseaudio
  ];

  meta = {
    homepage = "https://github.com/signalapp/ringrtc";
    description = "RingRTC library used by Signal";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
  };
})
