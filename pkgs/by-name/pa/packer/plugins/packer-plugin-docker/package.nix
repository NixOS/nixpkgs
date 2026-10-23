{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-docker";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-docker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rv12zSAH8TbbrRKk1/gd558EYTlBeBdHRMD6OQA6Xrg=";
  };

  vendorHash = "sha256-He7xU6naVhwSatAntw/BgMIm+3vN5onCbaaH/6XmlIY=";

  meta = {
    description = "Packer plugin for Docker";
    homepage = "https://github.com/hashicorp/packer-plugin-docker";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
