{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "kms-alicloud";
  pluginType = "kms";
  pluginName = "alicloudkms";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "kms-alicloud-v${finalAttrs.version}";
    hash = "sha256-LlwGH3C4eG3dkTb0yWaD6scmJ9OprCULvTmvU7CMvkQ=";
  };

  vendorHash = "sha256-fY20ZgdqLkA+myIDTHKvaBzTqfu2jwu4+FJR0/yNtKU=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal via AliCloud";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
