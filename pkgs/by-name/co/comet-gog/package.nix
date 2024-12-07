{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "comet-gog";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "comet";
    rev = "refs/tags/v${version}";
    hash = "sha256-LAEt2i/SRABrz+y2CTMudrugifLgHNxkMSdC8PXYF0E=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-eXPVImew1EOT1DcoeIVPhqQ2buqHnlpqT6A0eaqG7tI=";

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
