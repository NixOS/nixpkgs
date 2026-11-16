{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-vagrant";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-vagrant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kx6EBekBgYl2hD6rWWDSX9ar5KJjU0voNrbOzotfu5w=";
  };

  vendorHash = "sha256-49tupxkWxcgBsq186oEm61Suf+eIfB4uT15EetQtmFE=";

  meta = {
    description = "Packer plugin for Vagrant";
    homepage = "https://github.com/hashicorp/packer-plugin-vagrant";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
