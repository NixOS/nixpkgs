{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "auth-azure";
  pluginType = "auth";
  pluginName = "azure";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "auth-azure-v${finalAttrs.version}";
    hash = "sha256-XdyOvP6IILbzm1JWqdcrVdLYEG6VKqe2Wh6XmhLrZyw=";
  };

  vendorHash = null;

  meta = {
    description = "OpenBao auth plugin to authenticate using Microsoft Azure credentials";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
