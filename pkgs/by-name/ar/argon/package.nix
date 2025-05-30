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
  version = "2.0.24";

  src = fetchFromGitHub {
    owner = "argon-rbx";
    repo = "argon";
    tag = version;
    hash = "sha256-2E9vyXTLCqW5zzCal9FjmV3LvLymjfUbzwZJB77FilU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-j9aSnyc65CeBdgoFevdn1xpJHs4xWMhFDoRiPizceTI=";

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
