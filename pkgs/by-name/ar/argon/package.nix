{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  zstd,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "argon";
  version = "2.0.27";

  src = fetchFromGitHub {
    owner = "argon-rbx";
    repo = "argon";
    tag = finalAttrs.version;
    hash = "sha256-AcgaY7XmecqvWan81tVxV6UJ+A38tAYDlvUSLLKlYuU=";
  };

  cargoHash = "sha256-0VIPAcCK7+te7TgH/+x0Y7pP0fYWuRT58/h9OIva0mQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Full featured tool for Roblox development";
    homepage = "https://github.com/argon-rbx/argon";
    changelog = "https://github.com/argon-rbx/argon/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ StayBlue ];
    mainProgram = "argon";
  };
})
