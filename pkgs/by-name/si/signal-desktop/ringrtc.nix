{
  rustPlatform,
  lib,
  fetchFromGitHub,
  cmake,
  protobuf,
  webrtc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ringrtc";
  version = "2.50.4";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "ringrtc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r2HyhrYCCPdV5tFayHyY4R3qjK8ksF56Wq98GuQWmO0=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-QkEqtv/novbQOcaHKE51ivQjY4mf6Gju4uM7AT7j1P0=";

  cargoBuildFlags = [
    "-p"
    "ringrtc"
    "--features"
    "electron"
  ];
  doCheck = false;

  nativeBuildInputs = [
    protobuf
    cmake
  ];
  buildInputs = [
    webrtc
  ];

  meta = {
    homepage = "https://github.com/signalapp/ringrtc";
    description = "RingRTC library used by Signal";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
  };
})
