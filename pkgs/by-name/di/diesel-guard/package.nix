{
  lib,
  fetchCrate,
  nix-update-script,
  diesel-guard,
  testers,
  libpq,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "diesel-guard";
  version = "0.12.0";

  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "diesel-guard";
    hash = "sha256-sU6qKWlR44m19MeOEO/8L8R8dUJCUq6NbA4D3uJ15bM=";
  };

  cargoHash = "sha256-ZKJZnvv0EcGCljpjAVor9vt/eeN9ferw67z/RPTCcVU=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ libpq ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = diesel-guard; };
  };

  meta = {
    description = "Linter for dangerous Postgres migration patterns in Diesel and SQLx";
    homepage = "https://github.com/ayarotsky/diesel-guard";
    changelog = "https://github.com/ayarotsky/diesel-guard/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Dietr1ch ];
    mainProgram = "diesel-guard";
  };
})
