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
  version = "0.9.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "heiko";
    repo = "rsop";
    rev = "rsop/v${version}";
    hash = "sha256-rjlkXiG96TbAt7JLbEC/ExKAOfMpGbTc/ZXjLSXN3lw=";
  };

  cargoHash = "sha256-6o/JF25KJIKYtdeC9/ezAdwLk2GOGCu2r2FSLGxGzeY=";

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
