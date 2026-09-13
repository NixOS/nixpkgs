{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "auth-gcp";
  pluginType = "auth";
  pluginName = "gcp";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "auth-gcp-v${finalAttrs.version}";
    hash = "sha256-XdyOvP6IILbzm1JWqdcrVdLYEG6VKqe2Wh6XmhLrZyw=";
  };

  vendorHash = null;

  meta = {
    description = "OpenBao auth plugin to authenticate using Google Cloud Platform credentials";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
