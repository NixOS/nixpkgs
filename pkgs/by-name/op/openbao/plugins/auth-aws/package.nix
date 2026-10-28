{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "auth-aws";
  pluginType = "auth";
  pluginName = "aws";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "auth-aws-v${finalAttrs.version}";
    hash = "sha256-tPHFsVNqeIfJj1xXE8B2rKHcp8AnbLMBJSEoeA18VTM=";
    # The vendored tree has paths that only differ in case, which
    # collide on case-insensitive filesystems.
    postFetch = "rm -rf $out/vendor";
  };

  vendorHash = "sha256-0ekXPHzwzvTjp9Wpb7SfjDF69Vgi7HVaW0boXCAYrWM=";

  meta = {
    description = "OpenBao auth plugin to authenticate using AWS IAM credentials";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
