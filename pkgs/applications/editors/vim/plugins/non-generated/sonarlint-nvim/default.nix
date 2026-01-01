{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "sonarlint.nvim";
<<<<<<< HEAD
  version = "0-unstable-2025-12-08";
=======
  version = "0-unstable-2025-10-04";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "schrieveslaach";
    repo = "sonarlint.nvim";
<<<<<<< HEAD
    rev = "02c5d3ca44d8885eefc5430f685d21945c342ef3";
    hash = "sha256-juD35PuRCEBThZ5RPTHz/CoLae9JbXxa5Vyp99aInsY=";
=======
    rev = "1d49a469265e271f02b6efcf09c215e4560bd5fa";
    hash = "sha256-1eUwgHvegULo33xVjvV3b90fSlJ8Ax10iDCZE4IPo58=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://gitlab.com/schrieveslaach/sonarlint.nvim";
    description = "Extensions for the built-in Language Server Protocol support in Neovim for sonarlint-language-server";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.sinics ];
  };
}
