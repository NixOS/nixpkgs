{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "bitbake-vim";
  version = "2.8.8";

  src = fetchFromGitHub {
    owner = "openembedded";
    repo = "bitbake";
    tag = version;
    hash = "sha256-ShNMTsDL2N2BxwsHetn9rSQdWUBtF/N1EVAbYHXgBSY=";
  };

  sourceRoot = "source/contrib/vim";

  meta.homepage = "https://github.com/openembedded/bitbake/";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(\\d+\\.\\d+\\.\\d+)$"
    ];
  };
}
