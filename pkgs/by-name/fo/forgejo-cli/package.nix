{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  libgit2,
  oniguruma,
  openssl,
  zlib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "forgejo-cli";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Cyborus";
    repo = "forgejo-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8KPR7Fx26hj5glKDjczCLP6GgQBUsA5TpjhO5UZOpik=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kW7Pexydkosaufk1e8P5FaY+dgkeeTG5qgJxestWkVs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    oniguruma
    openssl
    zlib
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    BUILD_TYPE = "nixpkgs";
  };

  meta = {
    description = "CLI application for interacting with Forgejo";
    homepage = "https://codeberg.org/Cyborus/forgejo-cli";
    changelog = "https://codeberg.org/Cyborus/forgejo-cli/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      awwpotato
      isabelroses
    ];
    mainProgram = "fj";
  };
})
