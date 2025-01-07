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
    rev = "refs/tags/${version}";
    hash = "sha256-msKrPLB+38PU7LEw92xEqFy6JxwMjttBaobIOhU7eWw=";
  };

  cargoHash = "sha256-yXhEgZYtYhrSpwPbL+yi9gaLVVV8sBlF8m3ADUC4kLk=";

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
