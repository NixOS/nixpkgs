{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-oneandone";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-oneandone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H16HxXwVMO3IKncPaK67vuvoePwrvoleB3RyHG61PEw=";
  };

  vendorHash = "sha256-qTdseoxyLrG21zHp95f+DQ+MfNIbuPMCAoihBv7uRTQ=";

  meta = {
    description = "Packer plugin for 1&1";
    homepage = "https://github.com/hashicorp/packer-plugin-oneandone";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
