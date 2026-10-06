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

  vendorHash = "sha256-VzYdX3uV884+q+QpS6O3GIh8DhplF787RE2+2KWsOCs=";

  meta = {
    description = "OpenBao KMS plugin for Auto Unseal via OVHcloud";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
