{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "kms-alicloud";
  pluginType = "kms";
  pluginName = "alicloudkms";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "kms-alicloud-v${finalAttrs.version}";
    hash = "sha256-TD2xQQEOOLS9yUtoRyVt61auOpNh+zUv/CrRRplYTB4=";
  };

  vendorHash = "sha256-bgFfpT1CElxt3FyZoMRYc1M2UAXa/4iow42DUrP7x2E=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal via AliCloud";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
