{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-cloudstack";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-cloudstack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uZazRrUcA7w3QzEcyNCJXT0A50Xuq5ZRHEozRmO/oGQ=";
  };

  vendorHash = "sha256-GP56XVGelgceqy0HM7Hp0Sq1uHGkNwRkoxrhGlE8gl8=";

  meta = {
    description = "Packer plugin for CloudStack";
    homepage = "https://github.com/hashicorp/packer-plugin-cloudstack";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
