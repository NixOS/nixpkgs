{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "kms-oci";
  pluginType = "kms";
  pluginName = "ocikms";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "kms-oci-v${finalAttrs.version}";
    hash = "sha256-TD2xQQEOOLS9yUtoRyVt61auOpNh+zUv/CrRRplYTB4=";
  };

  vendorHash = "sha256-gGERjo6RAFofgkAl/b8cmepNeQWivq9TFUnfBjeZxXQ=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal via Oracle Cloud";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
