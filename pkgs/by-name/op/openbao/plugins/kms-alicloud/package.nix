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

  vendorHash = "sha256-gGERjo6RAFofgkAl/b8cmepNeQWivq9TFUnfBjeZxXQ=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal via AliCloud";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
