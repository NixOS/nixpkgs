{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  protobuf,
  libloragw-2g4,
  libloragw-sx1301,
  libloragw-sx1302,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-concentratord";
  version = "4.4.8";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-concentratord";
    rev = "v${version}";
    hash = "sha256-koEzUTbeuTjeoHmZc6hP2cZM66d0toI9YExGRtDjNBQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JRcVigA5yDsW4otPMvi3udjasQWQNrWJQ6zd6XXyQIk=";

  buildInputs = [
    libloragw-2g4
    libloragw-sx1301
    libloragw-sx1302
  ];

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ];

  updateScript = nix-update-script { };

  meta = {
    description = "Concentrator HAL daemon for LoRa gateways";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    platforms = lib.platforms.linux;
    mainProgram = "chirpstack-concentratord";
  };
}
