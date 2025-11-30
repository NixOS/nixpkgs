{
  rustPlatform,
  lib,
  fetchFromGitHub,
  cmake,
  protobuf,
  webrtc,
  pkg-config,
  cubeb,
}:
let
  cubeb' = cubeb.override {
    alsaSupport = false;
    pulseSupport = true;
    jackSupport = false;
    sndioSupport = false;
    enableShared = false;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ringrtc";
  version = "2.59.4";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "ringrtc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yj2ARjQsEDoempZmX+N4whhyTiLxDPR6Y/qeeku9GOQ=";
  };

  cargoHash = "sha256-b17tO22CtVl4JK0ABD7h+JyyYwLOK1VTKTSKIGim2yQ=";

  preConfigure = ''
    # Check for matching webrtc version
    grep 'webrtc.version=${webrtc.version}' config/version.properties
  '';

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
  ]
  # Workaround for https://github.com/NixOS/nixpkgs/pull/394607
  ++ cubeb'.buildInputs;

  meta = {
    homepage = "https://github.com/signalapp/ringrtc";
    description = "RingRTC library used by Signal";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
  };
})
