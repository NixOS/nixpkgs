{
  lib,
  rustPlatform,
  fetchCrate,
<<<<<<< HEAD
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rune";
  version = "0.14.1";

  src = fetchCrate {
    pname = "rune-cli";
    inherit (finalAttrs) version;
    hash = "sha256-Y/iCH6hwYRhDnu+lPVcJd2YaK3c4YJbfp9VEP1/c1ic=";
  };

  cargoHash = "sha256-Xp87BvDh3uPtvUMmG1R8g6lEZcf/frEHVXdQ/+kV5OI=";

  env = {
    RUNE_VERSION = finalAttrs.version;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interpreter for the Rune Language, an embeddable dynamic programming language for Rust";
    homepage = "https://rune-rs.github.io/";
    changelog = "https://github.com/rune-rs/rune/releases/tag/${finalAttrs.version}";
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "rune";
  version = "0.13.4";

  src = fetchCrate {
    pname = "rune-cli";
    inherit version;
    hash = "sha256-+2eXTkn9yOMhvS8cFwAorLBNIPvIRwsPOsGCl3gtRSE=";
  };

  cargoHash = "sha256-SgfgoMqr2Cc7+qhf9Ejl4Ect1JR9RqI9I0b+PrdvdOs=";

  env = {
    RUNE_VERSION = version;
  };

  meta = {
    description = "Interpreter for the Rune Language, an embeddable dynamic programming language for Rust";
    homepage = "https://rune-rs.github.io/";
    changelog = "https://github.com/rune-rs/rune/releases/tag/${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "rune";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
