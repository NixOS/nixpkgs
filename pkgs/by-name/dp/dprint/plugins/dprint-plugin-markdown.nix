{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Markdown code formatter";
  hash = "sha256-2lpgVMExOjMVRTvX6hGRWuufwh2AIkiXaOzkN8LhZgw=";
  initConfig = {
    configExcludes = [ ];
    configKey = "markdown";
    fileExtensions = [ "md" ];
  };
  pname = "dprint-plugin-markdown";
  updateUrl = "https://plugins.dprint.dev/dprint/markdown/latest.json";
  url = "https://plugins.dprint.dev/markdown-0.19.0.wasm";
  version = "0.19.0";
}
