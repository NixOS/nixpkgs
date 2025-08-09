{ mkDprintPlugin }:
mkDprintPlugin {
  description = "GraphQL formatter";
  hash = "sha256-PlQwpR0tMsghMrOX7is+anN57t9xa9weNtoWpc0E9ec=";
  initConfig = {
    configExcludes = [ ];
    configKey = "graphql";
    fileExtensions = [
      "graphql"
      "gql"
    ];
  };
  pname = "g-plane-pretty_graphql";
  updateUrl = "https://plugins.dprint.dev/g-plane/pretty_graphql/latest.json";
  url = "https://plugins.dprint.dev/g-plane/pretty_graphql-v0.2.1.wasm";
  version = "0.2.1";
}
