{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-openstack";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-openstack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U+1JXMGjNe/mA3ut55f0ZshwrmGiEMPxYcH/P7R3seU=";
  };

  vendorHash = "sha256-UZMxHidxQkJ02P8NB08UO+ArsOMAiEbqf49q5BOVqwc=";

  meta = {
    description = "Packer plugin for OpenStack";
    homepage = "https://github.com/hashicorp/packer-plugin-openstack";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
