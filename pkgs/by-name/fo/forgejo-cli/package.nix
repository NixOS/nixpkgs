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
  version = "0.1.0";
in
rustPlatform.buildRustPackage {
  pname = "forgejo-cli";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Cyborus";
    repo = "forgejo-cli";
    rev = "v${version}";
    hash = "sha256-ph/Whmws13ZVORVY4HxJIFOKDgTevuXGFSVZm/sSRvE=";
  };

  cargoHash = "sha256-hZg8zLth11se7BoXR1Iv7WfsBqyhqnHint11Ef++cKM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    oniguruma
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "CLI application for interacting with Forgejo";
    homepage = "https://codeberg.org/Cyborus/forgejo-cli";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "fj";
  };
}
