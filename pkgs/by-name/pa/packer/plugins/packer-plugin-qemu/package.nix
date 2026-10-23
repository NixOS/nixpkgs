{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-qemu";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-qemu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hHAxagcOCgcf5rVdObWlWmKonV5GJDfxzyc1g5hdNnM=";
  };

  vendorHash = "sha256-l7ITkEiyzMnonVqLByQQnwL0idJ3b1lXYU8X6uH+Oqg=";

  meta = {
    description = "Packer plugin for QEMU";
    homepage = "https://github.com/hashicorp/packer-plugin-qemu";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
