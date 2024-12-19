{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  bzip2,
  xz,
  zstd,
  stdenv,
  darwin,
  git,
  rustup,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-dist";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    rev = "v${version}";
    hash = "sha256-R6uTuU+U9fAUx7JP2QD+mTaoSipuaOlqPiiPdXqgfhw=";
  };

  cargoHash = "sha256-Hx3xo4PVObtSk68pUIqCbploKN7AxbRD36uOl/QaVkM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      bzip2
      xz
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  nativeCheckInputs = [
    git
    rustup
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # remove tests that require internet access
  postPatch = ''
    rm cargo-dist/tests/integration-tests.rs
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tool for building final distributable artifacts and uploading them to an archive";
    mainProgram = "cargo-dist";
    homepage = "https://github.com/axodotdev/cargo-dist";
    changelog = "https://github.com/axodotdev/cargo-dist/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
      mistydemeo
    ];
  };
}
