{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "pls";
  version = "0.0.1-beta.9";

  src = fetchFromGitHub {
    owner = "pls-rs";
    repo = "pls";
    rev = "refs/tags/v${version}";
    hash = "sha256-ofwdhGpqYlADDY2BLe0SkoHWqSeRNtQaXK61zWVFXzw=";
  };

  cargoHash = "sha256-u9uge44epAi9UiROThUewCNzmgeEi/Gy9h9NxVUb0YM=";

  env.LIBGIT2_NO_VENDOR = "1";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      libgit2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  meta = {
    changelog = "https://github.com/pls-rs/pls/releases/tag/v${version}";
    description = "Prettier and powerful ls";
    homepage = "http://pls.cli.rs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pls";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
