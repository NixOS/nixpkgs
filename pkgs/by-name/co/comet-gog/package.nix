{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "comet-gog";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "comet";
    tag = "v${version}";
    hash = "sha256-oJSP/zqr4Jp09Rh15a3o1GWsTA0y22+Zu2mU0HXHLHY=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VY9+5QUJYYifLokf69laapCCBRYFo1BOd6kQpxO2wkc=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  env.PROTOC = lib.getExe' protobuf "protoc";

  meta = {
    changelog = "https://github.com/imLinguin/comet/releases/tag/v${version}";
    description = "Open Source implementation of GOG Galaxy's Communication Service";
    homepage = "https://github.com/imLinguin/comet";
    license = lib.licenses.gpl3Plus;
    mainProgram = "comet";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
