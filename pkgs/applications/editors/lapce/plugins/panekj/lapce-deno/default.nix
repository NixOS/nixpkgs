{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "panekj";
  name = "lapce-deno";
  version = "0.0.1+deno.1.41.0";
  hash = "sha256-m+aW3TVtaO4E263qPjMRJrjbixr5EHWzLeFRbpGs+pU=";
  meta = {
    description = "TypeScript, JavaScript and Markdown language support via Deno LSP";
    homepage = "https://plugins.lapce.dev/plugins/panekj/lapce-deno";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
