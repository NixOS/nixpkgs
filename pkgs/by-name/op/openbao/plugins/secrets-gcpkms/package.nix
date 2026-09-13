{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "secrets-gcpkms";
  pluginType = "secret";
  pluginName = "gcpkms";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "secrets-gcpkms-v${finalAttrs.version}";
    hash = "sha256-XdyOvP6IILbzm1JWqdcrVdLYEG6VKqe2Wh6XmhLrZyw=";
  };

  vendorHash = null;

  meta = {
    description = "OpenBao secrets plugin to encrypt data and manage keys via GCP KMS";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
