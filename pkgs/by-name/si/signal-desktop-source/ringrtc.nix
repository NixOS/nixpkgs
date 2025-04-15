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
  version = "2.50.3";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "ringrtc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EuryWZMMTkrDPheVv0wBsH+zL3LylxSSPS+nNnn3cmM=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-/c+tpTh5X05HLqAHsA/YvWxqy7TSUy49g6OtIQg+rMs=";

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
