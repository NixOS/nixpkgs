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
<<<<<<< HEAD
  version = "2.0.27";
=======
  version = "2.0.26";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "argon-rbx";
    repo = "argon";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-AcgaY7XmecqvWan81tVxV6UJ+A38tAYDlvUSLLKlYuU=";
  };

  cargoHash = "sha256-0VIPAcCK7+te7TgH/+x0Y7pP0fYWuRT58/h9OIva0mQ=";
=======
    hash = "sha256-3IftPWrBETU7zJLaB9uTrc08c37XGmFPPArzrlIFG3Q=";
  };

  cargoHash = "sha256-60BQ7PsKATq5jX5DqCGdOx3xvRzwm5TAM1RtKuPy49M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    changelog = "https://github.com/argon-rbx/argon/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ StayBlue ];
    mainProgram = "argon";
  };
}
