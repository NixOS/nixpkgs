{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "kms-pkcs11";
  pluginType = "kms";
  pluginName = "pkcs11";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "kms-pkcs11-v${finalAttrs.version}";
    hash = "sha256-baRz0N6FEKDgxTJfTl5j3utEXlecxACyBMEczZXXJkM=";
  };

  vendorHash = "sha256-s4BdLm1zZ7wAXckXtXr5tjE52zn4iFfma/xn0nKz6Mc=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal and External Keys via PKCS#11";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
