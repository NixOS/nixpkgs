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
  version = "0.5.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "heiko";
    repo = "rsop";
    rev = "rsop/v${version}";
    hash = "sha256-Jh2SrIyMduODr3e3War0jCwHH6UwfU8764txzrImCaA=";
  };

  cargoHash = "sha256-OUJXQr3pQGCao0Ra5o9eZF0Jhp818/u5Pm1KJIoJV5w=";

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
