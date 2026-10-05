{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "auth-azure";
  pluginType = "auth";
  pluginName = "azure";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "auth-azure-v${finalAttrs.version}";
    hash = "sha256-TSNCoV3jkMA/ArpG4wWsl8/qv7kFRArip6soHIfrTu0=";
    # The vendored tree has paths that only differ in case, which
    # collide on case-insensitive filesystems.
    postFetch = "rm -rf $out/vendor";
  };

  vendorHash = "sha256-O9+a+th8AyMuWR+mk3sAu+Dowx+UVBYrPdzjO75ZIMk=";

  meta = {
    description = "OpenBao auth plugin to authenticate using Microsoft Azure credentials";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
