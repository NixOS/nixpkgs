{ mkDprintPlugin }:
mkDprintPlugin {
  description = "GraphQL formatter";
  hash = "sha256-xEEBnmxxiIPNOePBDS2HG6lfAhR4l53w+QDF2mXdyzg=";
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
  url = "https://plugins.dprint.dev/g-plane/pretty_graphql-v0.2.3.wasm";
  version = "0.2.3";
}
