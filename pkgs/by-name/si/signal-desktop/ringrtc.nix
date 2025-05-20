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
  version = "2.51.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "ringrtc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PLrGLW6pDoCNpbWASxAqockAJRoeBrkBdxNOHYrQu4s=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-u38VOV2xdNG1WFox+SWT9ejJD1TjK0yAI6lCB9r75iY=";

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
