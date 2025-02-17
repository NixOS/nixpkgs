{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "nvim-julia-autotest";
  version = "0-unstable-2022-10-31";

  src = fetchFromGitLab {
    owner = "usmcamp0811";
    repo = "nvim-julia-autotest";
    rev = "b74e2f9c961e604cb56cc23f87188348bfa0f33f";
    hash = "sha256-IaNsbBe5q7PB9Q/N/Z9nEnP6jlkQ6+xlkC0TCFnJpkk=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Automatically run Julia tests when you save runtest.jl file";
    homepage = "https://gitlab.com/usmcamp0811/nvim-julia-autotest";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
