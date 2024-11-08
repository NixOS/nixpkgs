{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Mikastiv";
  name = "ocean-space-refined";
  version = "0.1.2";
  hash = "sha256-+n9Q+e9qzGOqH4hgyh5m09flCpcujhw/6osKdaAqWu8=";
  meta = {
    description = "The Deep Oceanic Blue Theme";
    homepage = "https://plugins.lapce.dev/plugins/Mikastiv/ocean-space-refined";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
