{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "abreumatheus";
  name = "lapce-pyright";
  version = "0.1.1";
  hash = "sha256-C1YOg6WcRcN7+br9eCiUzSQVAj/JloH9+fY9IME1bpg=";
  meta = {
    description = "Pyright LSP for the Lapce editor.";
    homepage = "https://plugins.lapce.dev/plugins/abreumatheus/lapce-pyright";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
