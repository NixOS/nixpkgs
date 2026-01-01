{
  lib,
  fetchFromGitHub,
  rustPlatform,
<<<<<<< HEAD
  openssl,
  pkg-config,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chess-tui";
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.6.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "thomas-mauran";
    repo = "chess-tui";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-SIQoi/pnbS1TyX6iA8azo0nVfsCQd6ntn9VZCz/Zkgw=";
  };

  cargoHash = "sha256-aWj8ruu/Y/VCgvhAkWVfDDztmVzHsZix88JUAOYttmg=";
=======
    hash = "sha256-OGzYxFGHSH1X8Q8dcB35on/2D+sc0e+chtgObOWUGGM=";
  };

  cargoHash = "sha256-JfX2JWQVrVvq/P/rFumO9QAeJSTxXIKXJxjXmvl1y+g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  checkFlags = [
    # assertion failed: result.is_ok()
    "--skip=tests::test_config_create"
  ];

<<<<<<< HEAD
  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];
  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Chess TUI implementation in rust";
    homepage = "https://github.com/thomas-mauran/chess-tui";
    maintainers = with lib.maintainers; [ ByteSudoer ];
    license = lib.licenses.mit;
    mainProgram = "chess-tui";
  };
})
