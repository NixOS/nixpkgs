{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "kms-tcloudpublic";
  pluginType = "kms";
  pluginName = "tcloudpublic";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "kms-tcloudpublic-v${finalAttrs.version}";
    hash = "sha256-TD2xQQEOOLS9yUtoRyVt61auOpNh+zUv/CrRRplYTB4=";
  };

  vendorHash = "sha256-gGERjo6RAFofgkAl/b8cmepNeQWivq9TFUnfBjeZxXQ=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal via T Cloud Public";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
