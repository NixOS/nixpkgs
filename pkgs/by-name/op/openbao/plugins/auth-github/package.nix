{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "auth-github";
  pluginType = "auth";
  pluginName = "github";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "auth-github-v${finalAttrs.version}";
    hash = "sha256-LlwGH3C4eG3dkTb0yWaD6scmJ9OprCULvTmvU7CMvkQ=";
    # The vendored tree has paths that only differ in case, which
    # collide on case-insensitive filesystems.
    postFetch = "rm -rf $out/vendor";
  };

  vendorHash = "sha256-fY20ZgdqLkA+myIDTHKvaBzTqfu2jwu4+FJR0/yNtKU=";

  meta = {
    description = "OpenBao auth plugin to authenticate using GitHub credentials";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
