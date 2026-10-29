{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "secrets-ldap";
  pluginType = "secret";
  pluginName = "ldap";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "secrets-ldap-v${finalAttrs.version}";
    hash = "sha256-LlwGH3C4eG3dkTb0yWaD6scmJ9OprCULvTmvU7CMvkQ=";
  };

  vendorHash = "sha256-fY20ZgdqLkA+myIDTHKvaBzTqfu2jwu4+FJR0/yNtKU=";

  meta = {
    description = "OpenBao secrets plugin to generate and manage LDAP credentials";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
