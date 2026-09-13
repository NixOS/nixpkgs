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

  vendorHash = "sha256-8hmws5BlE9nHYR2zPku0iavF57Q0IdH/Hobrmg0lNVU=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal and External Keys via PKCS#11";
    maintainers = with lib.maintainers; [ kranzes ];
    platforms = lib.platforms.linux;
  };
})
