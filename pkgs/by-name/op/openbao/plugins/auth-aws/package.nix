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
    hash = "sha256-fOFGjEhX+vqPN5JcJ0240QBtMO6opcoVMz68zIKAIuA=";
  };

  vendorHash = null;

  meta = {
    description = "OpenBao auth plugin to authenticate using AWS IAM credentials";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
