{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "oknozor";
  name = "lapce-java";
  version = "0.3.0";
  hash = "sha256-KbODyIE5QOxCjRBR3c2efuf6QlfxGPLS6zYnMkkUm5s=";
  meta = {
    description = "Lapce LSP plugin for java, powered by Eclipse JDT Language Server";
    homepage = "https://plugins.lapce.dev/plugins/oknozor/lapce-java";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
