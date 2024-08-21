{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "WalterOfNone";
  name = "ayu";
  version = "0.1.2";
  hash = "sha256-8m9joh8VTkd4fzNevFmZROsQ5Cl7si84oVQ01nTCjdo=";
  meta = {
    description = "The Ayu theme";
    homepage = "https://plugins.lapce.dev/plugins/WalterOfNone/ayu";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
