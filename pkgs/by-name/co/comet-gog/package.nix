{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  darwin,
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation SystemConfiguration;
in
rustPlatform.buildRustPackage rec {
  pname = "comet-gog";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "comet";
    rev = "refs/tags/v${version}";
    hash = "sha256-TdIqdNn5HnIED7LMn4qAzKPHlA5t/Q1Dn+W+ulx5qOU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-gAGCpcVjOkUZa/CobOjOt07WMHpvE5/q1bw+z4yBeNE=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  env.PROTOC = lib.getExe' protobuf "protoc";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    SystemConfiguration
  ];

  meta = {
    changelog = "https://github.com/imLinguin/comet/releases/tag/v${version}";
    description = "Open Source implementation of GOG Galaxy's Communication Service";
    homepage = "https://github.com/imLinguin/comet";
    license = lib.licenses.gpl3Plus;
    mainProgram = "comet";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
