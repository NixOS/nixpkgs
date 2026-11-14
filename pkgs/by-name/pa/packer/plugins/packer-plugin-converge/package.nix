{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-converge";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-converge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZSEguniezoP+yccXBobuzjeOyrKBZ+qjeI2B8CsIyVU=";
  };

  vendorHash = "sha256-h+BZydIrt1xTXV8JHWItV+zCC6btkbPgJp/JKfwGRfQ=";

  meta = {
    description = "Packer plugin for Converge";
    homepage = "https://github.com/hashicorp/packer-plugin-converge";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
