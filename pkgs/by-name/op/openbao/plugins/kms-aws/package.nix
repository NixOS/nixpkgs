{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "kms-aws";
  pluginType = "kms";
  pluginName = "awskms";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "kms-aws-v${finalAttrs.version}";
    hash = "sha256-TD2xQQEOOLS9yUtoRyVt61auOpNh+zUv/CrRRplYTB4=";
  };

  vendorHash = "sha256-gGERjo6RAFofgkAl/b8cmepNeQWivq9TFUnfBjeZxXQ=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal via AWS";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
