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
  version = "2.0.21";

  src = fetchFromGitHub {
    owner = "argon-rbx";
    repo = "argon";
    tag = version;
    hash = "sha256-msKrPLB+38PU7LEw92xEqFy6JxwMjttBaobIOhU7eWw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HOgwN/LwnHq+BxiniTFbBwCw0Qc6kxcH8GrAy/JggXo=";

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
