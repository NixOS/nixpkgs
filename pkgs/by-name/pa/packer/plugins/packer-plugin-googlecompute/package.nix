{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-googlecompute";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-googlecompute";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c03UZdswKvHJbOWWITX5TQ08jfBfRpri3y2+6wRuXr8=";
  };

  vendorHash = "sha256-yRDNWloQZVSeGaoKdxgoxN8OCqzOnExNOxXJ7yByd+E=";

  meta = {
    description = "Packer plugin for Google Compute Engine";
    homepage = "https://github.com/hashicorp/packer-plugin-googlecompute";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
