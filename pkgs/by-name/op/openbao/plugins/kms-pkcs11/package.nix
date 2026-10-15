{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "kms-pkcs11";
  pluginType = "kms";
  pluginName = "pkcs11";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "kms-pkcs11-v${finalAttrs.version}";
    hash = "sha256-tHVSxxCRWyFlYsFpwnfPBhjkOw9unCDI+oQv6x1gqgU=";
  };

  vendorHash = "sha256-CQoqb0IGOliRNOqjE/I2rmMcx3h02fGaWFUJaUzzDcE=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal and External Keys via PKCS#11";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
