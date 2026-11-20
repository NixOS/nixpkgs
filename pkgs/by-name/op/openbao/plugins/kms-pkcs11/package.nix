{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "kms-pkcs11";
  pluginType = "kms";
  pluginName = "pkcs11";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "kms-pkcs11-v${finalAttrs.version}";
    hash = "sha256-T246P+/zuVdJ3xGG/e7dem9EWZ90TZr6lhvP8cS3/9s=";
  };

  vendorHash = "sha256-Rt6NHIMfUaORvbt5Y+OLDc8ahZa09WJI5oPjB4gZejQ=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal and External Keys via PKCS#11";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
