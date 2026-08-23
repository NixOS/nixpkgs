{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-lxd";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-lxd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NMTdyxrQtzYJhYaUYbScFGqCkSr23hoyWJk6AVd+sio=";
  };

  vendorHash = "sha256-db043PTjfoBkmt8b5O8YpQsi1TWvQaWSRiucXSxg3S4=";

  meta = {
    description = "Packer plugin for LXD";
    homepage = "https://github.com/hashicorp/packer-plugin-lxd";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
