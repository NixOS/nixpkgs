{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "kms-ovhcloud";
  pluginType = "kms";
  pluginName = "ovhcloud";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "kms-ovhcloud-v${finalAttrs.version}";
    hash = "sha256-6llY6SBKljQfmiYN+GxZ3aRgdSTW2PLMwviIJcnYZrw=";
  };

  vendorHash = "sha256-nf/YCz8wzWdyZXiLWz9jXDp8qKFZU+ZlbGj/X9eXIb8=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal via OVHcloud";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
