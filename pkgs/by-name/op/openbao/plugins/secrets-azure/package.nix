{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "secrets-azure";
  pluginType = "secret";
  pluginName = "azure";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "secrets-azure-v${finalAttrs.version}";
    hash = "sha256-XdyOvP6IILbzm1JWqdcrVdLYEG6VKqe2Wh6XmhLrZyw=";
  };

  vendorHash = null;

  meta = {
    description = "OpenBao secrets plugin to generate Azure service principals with role and group assignments";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
