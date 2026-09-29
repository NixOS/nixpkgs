{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-virtualbox";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-virtualbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SQCkEvc0Bs3PX/QYZDzjNdzkkmJc5XF2RCi/sP22A4E=";
  };

  vendorHash = "sha256-S7WwlCdMd+m+Y5fgLhSzH4CGPBLBGwJ6KXCqPuYh2ws=";

  meta = {
    description = "Packer plugin for VirtualBox";
    homepage = "https://github.com/hashicorp/packer-plugin-virtualbox";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
