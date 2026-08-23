{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-commander-rs";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SyAKKSPGO8yjP3Pgsr2sPW5cpNyNLiYTy7CDDAXdztw=";
  };

  cargoHash = "sha256-X1xBhJ0B4FcC66qKtYZbcX2+92hy2R4fM/GYBI8AFTY=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  meta = {
    description = "CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander-rs";
    changelog = "https://github.com/8go/matrix-commander-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "matrix-commander-rs";
  };
})
