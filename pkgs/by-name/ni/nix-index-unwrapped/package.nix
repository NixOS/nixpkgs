{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  curl,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-index";
  version = "0.1.9-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-index";
    rev = "0f68b51886bde4014629e43d9be4b66cff450990";
    hash = "sha256-polUDx4tWFmyxsn83XRrw9YQlDq/ggNY1hq6xw9NOoQ=";
  };

  cargoHash = "sha256-2Ar7mj9r5eKdbXDC4+jSWG7HvGFTeowEPt2SBM6a6e4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    curl
    sqlite
  ];

  postInstall = ''
    substituteInPlace command-not-found.sh \
      --subst-var out
    install -Dm555 command-not-found.sh -t $out/etc/profile.d
    substituteInPlace command-not-found.nu \
      --subst-var out
    install -Dm555 command-not-found.nu -t $out/etc/profile.d
  '';

  meta = {
    description = "Files database for nixpkgs";
    homepage = "https://github.com/nix-community/nix-index";
    changelog = "https://github.com/nix-community/nix-index/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [
      bennofs
      ncfavier
    ];
    mainProgram = "nix-index";
  };
})
