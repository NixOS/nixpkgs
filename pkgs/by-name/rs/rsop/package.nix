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
<<<<<<< HEAD
  version = "0.9.2";
=======
  version = "0.9.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "heiko";
    repo = "rsop";
    rev = "rsop/v${version}";
<<<<<<< HEAD
    hash = "sha256-rjlkXiG96TbAt7JLbEC/ExKAOfMpGbTc/ZXjLSXN3lw=";
  };

  cargoHash = "sha256-6o/JF25KJIKYtdeC9/ezAdwLk2GOGCu2r2FSLGxGzeY=";
=======
    hash = "sha256-LlTKPiBqc0mED3co/d4elo/QkBOhjppOQrrsn3Kwfv4=";
  };

  cargoHash = "sha256-UFgGMmDeeIKK3L/1f+UCaZKykC7ORIFpMU31Pi1JtHQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
