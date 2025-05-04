{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "bitbake-vim";
  version = "2.10.4";

  # The tags are very messy on the upstream repo. We prefer disabling automatic updates for this plugin.
  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "openembedded";
    repo = "bitbake";
    tag = version;
    hash = "sha256-gdxPnRhd4Hj1PWgCU5A/+639ndJXlkdArOBZt6eiZWA=";
  };

  sourceRoot = "source/contrib/vim";

  meta.homepage = "https://github.com/openembedded/bitbake/";
}
