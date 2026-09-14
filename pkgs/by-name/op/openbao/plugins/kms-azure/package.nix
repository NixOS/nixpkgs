{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "kms-azure";
  pluginType = "kms";
  pluginName = "azurekeyvault";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "kms-azure-v${finalAttrs.version}";
    hash = "sha256-TD2xQQEOOLS9yUtoRyVt61auOpNh+zUv/CrRRplYTB4=";
  };

  vendorHash = "sha256-bgFfpT1CElxt3FyZoMRYc1M2UAXa/4iow42DUrP7x2E=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal via Azure";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
