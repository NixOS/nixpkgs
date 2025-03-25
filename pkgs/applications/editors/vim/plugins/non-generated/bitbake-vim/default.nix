{
  vimUtils,
  fetchFromGitHub,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "bitbake-vim";
  version = "2025-03-24";

  src = fetchFromGitHub {
    owner = "openembedded";
    repo = "bitbake";
    rev = "8cc976e2792fdde3900729f3b09dd18ab640b5e8";
    sha256 = "12k48zhd9bh3b8xjpang2xj14nhyla2p55r1is3m25wkqys10p9c";
  };

  sourceRoot = "source/contrib/vim";

  meta.homepage = "https://github.com/openembedded/bitbake/";

  passthru.updateScript = nix-update-script { };
}
