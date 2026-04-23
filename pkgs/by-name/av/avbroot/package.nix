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
  version = "3.29.1";

  src = fetchFromGitHub {
    owner = "chenxiaolong";
    repo = "avbroot";
    tag = "v${version}";
    hash = "sha256-xzCm4gxN6jnUU44QyXq/Ra/yqiffD0ZBNAzGCoP7Nec=";
  };

  cargoHash = "sha256-H7aBxi/1ibDRZUIOYjrJ4NczX8YaLrBn4eaP/SuzvT4=";

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
