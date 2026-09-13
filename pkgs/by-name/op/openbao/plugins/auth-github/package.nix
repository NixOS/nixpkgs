{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "auth-github";
  pluginType = "auth";
  pluginName = "github";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "auth-github-v${finalAttrs.version}";
    hash = "sha256-deU9pjtvDA26MUJL+LJjEZEuoqmYWadIsMvVxvLVj1w=";
  };

  vendorHash = null;

  meta = {
    description = "OpenBao auth plugin to authenticate using GitHub credentials";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
