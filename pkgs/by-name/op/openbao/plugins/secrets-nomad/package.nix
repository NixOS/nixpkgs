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

  vendorHash = "sha256-pKShDaQ7AcoTyZK14u8XIA+uL/3tRNIgbGF0J5p2CQI=";

  meta = {
    description = "OpenBao secrets plugin to generate Nomad ACL tokens";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
