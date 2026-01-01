{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
<<<<<<< HEAD
  version = "0-unstable-2025-12-23";
=======
  version = "0-unstable-2025-11-25";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
<<<<<<< HEAD
    rev = "e64fabb840a35ad1feeedc88b181dd8593c88d8b";
    hash = "sha256-npAMi7652BUG4coQjkLIcWcSQ4kH+aDwZXsPsLCeZdY=";
  };

  npmDepsHash = "sha256-Qksi1G4YeFU94mIccyMpphER9d/UiCOriqbe0w7LA6c=";
=======
    rev = "8bd84ab1c2b436a2e9fadf059b5785f43e877c1e";
    hash = "sha256-R9IQuoNGCqodbAkPnQLHi8sPzXvT3x+K9mt7apywips=";
  };

  npmDepsHash = "sha256-94kuqDNsCcPuvTVeprEdjNOPw8pdpDp3IOvuoKdSEgU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
