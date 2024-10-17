{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "NachiketNamjoshi";
  name = "gruvbox";
  version = "0.2.0";
  hash = "sha256-k7/MylUTXhQtVKHweTAl1ddkUotStr7rdsmmwYKEZOA=";
  meta = {
    description = "The Iconic Gruvbox Theme";
    homepage = "https://plugins.lapce.dev/plugins/NachiketNamjoshi/gruvbox";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
