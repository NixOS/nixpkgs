{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin rec {
  pname = "bitbake-vim";
  version = "2.0.26";

  src = fetchFromGitHub {
    owner = "openembedded";
    repo = "bitbake";
    tag = version;
    hash = "sha256-Er6zWDhqIYCWTjAQbfliKpFzoYampcrSZGuXcN9C/rk=";
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
