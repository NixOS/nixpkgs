{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Markdown code formatter.";
  hash = "sha256-PIEN9UnYC8doJpdzS7M6QEHQNQtj7WwXAgvewPsTjqs=";
  initConfig = {
    configExcludes = [ ];
    configKey = "markdown";
    fileExtensions = [ "md" ];
  };
  pname = "dprint-plugin-markdown";
  updateUrl = "https://plugins.dprint.dev/dprint/markdown/latest.json";
  url = "https://plugins.dprint.dev/markdown-0.17.8.wasm";
  version = "0.17.8";
}
