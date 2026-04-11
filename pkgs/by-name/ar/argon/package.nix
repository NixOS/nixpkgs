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
  version = "2.0.28";

  src = fetchFromGitHub {
    owner = "argon-rbx";
    repo = "argon";
    tag = finalAttrs.version;
    hash = "sha256-QXGiDcn5BM1psCZf88gEyKqoK9EDFquLgyzJeZOhwMU=";
  };

  cargoHash = "sha256-okfQn/dgBN6s1aO1cnU/bY7BIqwM9iq1iPZ321ez4C4=";

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
