{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  bzip2,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "avbroot";
  version = "3.18.1";

  src = fetchFromGitHub {
    owner = "chenxiaolong";
    repo = "avbroot";
    tag = "v${version}";
    hash = "sha256-+Syx8Hhpn6803SEIvB3ppa6mEVgU6SqSr1o6xy+OZsQ=";
  };

  cargoHash = "sha256-Wjwi/zvaS1fuAOx/OeclGSbyyPaqkIxQ3jfUPdLMMQQ=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [ bzip2 ];

  meta = {
    description = "Sign (and root) Android A/B OTAs with custom keys while preserving Android Verified Boot";
    homepage = "https://github.com/chenxiaolong/avbroot";
    changelog = "https://github.com/chenxiaolong/avbroot/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "avbroot";
  };
}
