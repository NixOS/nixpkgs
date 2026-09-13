{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "secrets-gcp";
  pluginType = "secret";
  pluginName = "gcp";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "secrets-gcp-v${finalAttrs.version}";
    hash = "sha256-4tmwAeMCOswUwip5eESgbU1duKf5lRcM2Y4Bn1oSGF0=";
  };

  vendorHash = "sha256-pKShDaQ7AcoTyZK14u8XIA+uL/3tRNIgbGF0J5p2CQI=";

  meta = {
    description = "OpenBao secrets plugin to generate GCP service account keys and OAuth tokens based on IAM policies";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
