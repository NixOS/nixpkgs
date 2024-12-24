{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  libgit2,
  oniguruma,
  openssl,
  zlib,
  stdenv,
  darwin,
}:
let
  version = "0.2.0";
in
rustPlatform.buildRustPackage {
  pname = "forgejo-cli";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Cyborus";
    repo = "forgejo-cli";
    rev = "v${version}";
    hash = "sha256-rHyPncAARIPakkv2/CD1/aF2G5AS9bb3T2x8QCQWl5o=";
  };

  cargoHash = "sha256-kIOEUDJg7/08L9c/qt7NrT8U+xN3Ya5PBWPWmWj0Yx8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      libgit2
      oniguruma
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
      ]
    );

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "CLI application for interacting with Forgejo";
    homepage = "https://codeberg.org/Cyborus/forgejo-cli";
    changelog = "https://codeberg.org/Cyborus/forgejo-cli/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "fj";
  };
}
