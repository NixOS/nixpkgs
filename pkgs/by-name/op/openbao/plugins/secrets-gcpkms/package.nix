{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "secrets-gcpkms";
  pluginType = "secret";
  pluginName = "gcpkms";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "secrets-gcpkms-v${finalAttrs.version}";
    hash = "sha256-LlwGH3C4eG3dkTb0yWaD6scmJ9OprCULvTmvU7CMvkQ=";
  };

  vendorHash = "sha256-fY20ZgdqLkA+myIDTHKvaBzTqfu2jwu4+FJR0/yNtKU=";

  meta = {
    description = "OpenBao secrets plugin to encrypt data and manage keys via GCP KMS";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
