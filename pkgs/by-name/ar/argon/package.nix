{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  zstd,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "argon";
  version = "2.0.23";

  src = fetchFromGitHub {
    owner = "argon-rbx";
    repo = "argon";
    tag = version;
    hash = "sha256-Pj6czSNFaMtu5fZV51lFDYEiWlMcj1peu7i8JUnFSXk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Lc9k6WDp7ZU4lBGbXJJATcH/+SQkbutMTgzmxZh2JCk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
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
    changelog = "https://github.com/argon-rbx/argon/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ StayBlue ];
    mainProgram = "argon";
  };
}
