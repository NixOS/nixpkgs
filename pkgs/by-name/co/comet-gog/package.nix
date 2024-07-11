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
rustPlatform.buildRustPackage {
  pname = "comet-gog";
  version = "0-unstable-2024-05-25";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "comet";
    rev = "378ec2abdc2498e7c0c12aa50b71f6d94c3e8e3c";
    hash = "sha256-r7ZPpJLy2fZsyNijl0+uYWQN941TCbv+Guv3wzD83IQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-dXNAGMVayzgT96ETrph9eCbQv28EK/OOxIRV8ewpVvs=";

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
    description = "Open Source implementation of GOG Galaxy's Communication Service";
    homepage = "https://github.com/imLinguin/comet";
    license = lib.licenses.gpl3Plus;
    mainProgram = "comet";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
