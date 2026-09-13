{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "database-mongodb";
  pluginType = "database";
  pluginName = "mongodb-database-plugin";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "database-mongodb-v${finalAttrs.version}";
    hash = "sha256-vsYNbdw5NI5upYjEomFwPyVyk8GkPY6aTxdjL3/AGD4=";
  };

  vendorHash = "sha256-nf/YCz8wzWdyZXiLWz9jXDp8qKFZU+ZlbGj/X9eXIb8=";

  meta = {
    description = "OpenBao database plugin to generate MongoDB database credentials";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
