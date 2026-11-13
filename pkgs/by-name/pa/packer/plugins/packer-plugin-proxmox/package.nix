{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-proxmox";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-proxmox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5v0Js0CHiJ15kL6RLc7ztWQVpiA49HpWCLsgA26mzmA=";
  };

  vendorHash = "sha256-T1AA7Wu0xeCXPKT/+Et4jV8V3ga2fXHS2MRw6W4gCHU=";

  meta = {
    description = "Packer plugin for Proxmox";
    homepage = "https://github.com/hashicorp/packer-plugin-proxmox";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
