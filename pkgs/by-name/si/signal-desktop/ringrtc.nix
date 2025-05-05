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
  version = "2.50.5";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "ringrtc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qBIm5gMwnTHR0PjO4xjyka0ebR6JAOcCJ/JqcyhPP6Q=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-VLefmYCotBwppcKUrVfi1ikfompQsaYZ9cYbHU93iwA=";

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
