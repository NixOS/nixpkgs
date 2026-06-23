{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  testers,
  pgcat,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pgcat";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "postgresml";
    repo = "pgcat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DHXUhAAOmPSt4aVp93I1y69of+MEboXJBZH50mzQTm8=";
  };

  cargoHash = "sha256-6x/IPFncfOPxautW7gVUh5LG0hK4h6T4QL7B82Moi6o=";

  checkFlags = [
    # requires network access
    "--skip=dns_cache"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = pgcat; };
  };

  meta = {
    homepage = "https://github.com/postgresml/pgcat";
    description = "PostgreSQL pooler with sharding, load balancing and failover support";
    changelog = "https://github.com/postgresml/pgcat/releases";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cathalmullan ];
    mainProgram = "pgcat";
  };
})
