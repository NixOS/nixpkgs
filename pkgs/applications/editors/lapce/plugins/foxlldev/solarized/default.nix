{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "foxlldev";
  name = "solarized";
  version = "0.1.1";
  hash = "sha256-649WE9BcR80HwKnEYEM3O5EgfAiKb/cZFM3bXjjf854=";
  meta = {
    description = "Solarized theme for Lapce editor";
    homepage = "https://plugins.lapce.dev/plugins/foxlldev/solarized";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
