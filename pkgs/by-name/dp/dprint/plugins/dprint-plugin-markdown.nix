{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Markdown code formatter.";
  hash = "sha256-fBy+G+DkJqhrCyyaMjmXRe1VeSeCYO+XmJ8ogwAoptA=";
  initConfig = {
    configExcludes = [ ];
    configKey = "markdown";
    fileExtensions = [ "md" ];
  };
  pname = "dprint-plugin-markdown";
  updateUrl = "https://plugins.dprint.dev/dprint/markdown/latest.json";
  url = "https://plugins.dprint.dev/markdown-0.18.0.wasm";
  version = "0.18.0";
}
