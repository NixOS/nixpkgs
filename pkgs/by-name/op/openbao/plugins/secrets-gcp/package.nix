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

  vendorHash = "sha256-eR4f+T5zDxpLp5oPqfKe8QUe2w9T0zM3E0vOQIRhsm8=";

  meta = {
    description = "OpenBao secrets plugin to generate GCP service account keys and OAuth tokens based on IAM policies";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
