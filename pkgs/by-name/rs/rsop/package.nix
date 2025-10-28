{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  pcsclite,
  nix-update-script,
  testers,
  rsop,
}:

rustPlatform.buildRustPackage rec {
  pname = "rsop";
  version = "0.8.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "heiko";
    repo = "rsop";
    rev = "rsop/v${version}";
    hash = "sha256-bbB2IefXauVV6LjpJxSNy4RVYjAGH0osTpUZGGscGec=";
  };

  cargoHash = "sha256-P27PnFNArKn3CQtik6TaV7eW/8bQiOZ57ZbMth2pNiY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pcsclite ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      command = "rsop version";
      package = rsop;
    };
  };

  meta = {
    homepage = "https://codeberg.org/heiko/rsop";
    description = "Stateless OpenPGP (SOP) based on rpgp";
    license = with lib.licenses; [
      mit
      apsl20
      cc0
    ];
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "rsop";
  };
}
