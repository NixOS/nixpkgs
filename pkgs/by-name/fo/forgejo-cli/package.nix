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

  useFetchCargoVendor = true;
  cargoHash = "sha256-PkKinAZrZ+v1/eygiPis4F7EJnmjYfeQFPKfGpza0yA=";

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
    changelog = "https://codeberg.org/Cyborus/forgejo-cli/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "fj";
  };
}
