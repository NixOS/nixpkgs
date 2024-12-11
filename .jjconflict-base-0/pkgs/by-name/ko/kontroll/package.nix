{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "kontroll";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "kontroll";
    rev = version;
    hash = "sha256-k7Twbjl8umk3PeIv3ivCLdhZFgTTV8WdfIAoGAD/pEk=";
  };

  cargoHash = "sha256-931PmSvcXTjxdIQUCSxLwFnaHgRrFzA/v6yYTvkjNoQ=";

  nativeBuildInputs = [ protobuf ];

  meta = {
    description = "Kontroll demonstates how to control the Keymapp API, making it easy to control your ZSA keyboard from the command line and scripts";
    homepage = "https://github.com/zsa/kontroll";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "kontroll";
  };
}
