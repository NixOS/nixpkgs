{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-qemu";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-qemu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ose7ueo9V2zJ5K5yvew9ErTD9lR+rkp1UB/yDi+U+fY=";
  };

  vendorHash = "sha256-pgfI/ntG6Fesimw3jk70GP+lBUEUMfq6wbqXx8xCTf0=";

  meta = {
    description = "Packer plugin for QEMU";
    homepage = "https://github.com/hashicorp/packer-plugin-qemu";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
