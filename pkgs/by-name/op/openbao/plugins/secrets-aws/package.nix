{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "secrets-aws";
  pluginType = "secret";
  pluginName = "aws";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "secrets-aws-v${finalAttrs.version}";
    hash = "sha256-hj1Q03GxEw9rQERx0Y8zEKMbnLJD0pkvyGzB8Jh+uUQ=";
  };

  vendorHash = "sha256-nf/YCz8wzWdyZXiLWz9jXDp8qKFZU+ZlbGj/X9eXIb8=";

  meta = {
    description = "OpenBao secrets plugin to generate AWS access credentials based on IAM policies";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
