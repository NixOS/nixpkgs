{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "bitbake-vim";
  version = "2.10.4";

  src = fetchFromGitHub {
    owner = "openembedded";
    repo = "bitbake";
    tag = version;
    hash = "sha256-gdxPnRhd4Hj1PWgCU5A/+639ndJXlkdArOBZt6eiZWA=";
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
