{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  pcsclite,
  nix-update-script,
  testers,
  rsop,
}:

rustPlatform.buildRustPackage rec {
  pname = "rsop";
  version = "0.9.3";

  src = fetchFromCodeberg {
    owner = "heiko";
    repo = "rsop";
    rev = "rsop/v${version}";
    hash = "sha256-eP3jh5TIhMHDWnttnYvBre/tfzxajLNGtInWNiFAPiw=";
  };

  cargoHash = "sha256-vmxqpOABd7S/htX8bbThyvfOSBY9f1CjX0gY9NQVHss=";

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
