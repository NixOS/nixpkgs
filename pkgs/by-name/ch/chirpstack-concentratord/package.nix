{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  protobuf,
  libloragw-2g4,
  libloragw-sx1301,
  libloragw-sx1302,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-concentratord";
  version = "4.4.2";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-concentratord";
    rev = "v${version}";
    hash = "sha256-UbUtNJuz8zfhHzyOiT/mRNtNRmdoNnuszrVSbLoVGK8=";
  };

  cargoHash = "sha256-JXIyrbBRGJR9mjvawU46mBfGYxZPpYl9aB9k3WBA/co=";

  buildInputs = [
    libloragw-2g4
    libloragw-sx1301
    libloragw-sx1302
  ];

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Concentrator HAL daemon for LoRa gateways";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    platforms = [ "aarch64-linux" ];
    mainProgram = "chirpstack-concentratord";
  };
}
