{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "secrets-nomad";
  pluginType = "secret";
  pluginName = "nomad";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "secrets-nomad-v${finalAttrs.version}";
    hash = "sha256-4tmwAeMCOswUwip5eESgbU1duKf5lRcM2Y4Bn1oSGF0=";
  };

  vendorHash = "sha256-eR4f+T5zDxpLp5oPqfKe8QUe2w9T0zM3E0vOQIRhsm8=";

  meta = {
    description = "OpenBao secrets plugin to generate Nomad ACL tokens";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
