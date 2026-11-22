{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "secrets-aws";
  pluginType = "secret";
  pluginName = "aws";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "secrets-aws-v${finalAttrs.version}";
    hash = "sha256-0NJ1a1taEuZzvP+FToSGVzjzXOpM0O3B+Y/5SKdFLoA=";
  };

  vendorHash = "sha256-Rt6NHIMfUaORvbt5Y+OLDc8ahZa09WJI5oPjB4gZejQ=";

  meta = {
    description = "OpenBao secrets plugin to generate AWS access credentials based on IAM policies";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
