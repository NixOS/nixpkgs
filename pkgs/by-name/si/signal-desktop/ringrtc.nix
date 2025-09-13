{
  rustPlatform,
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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ringrtc";
  version = "2.57.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "ringrtc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m73SXjTES1sHGbQRtn9CjurFd/Xby5Yyn6uLVLigfiU=";
  };

  cargoHash = "sha256-LRCgK/w+GcYBCWUKjytErQCxDtS15EnsVOr5Uq6F8ww=";

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
