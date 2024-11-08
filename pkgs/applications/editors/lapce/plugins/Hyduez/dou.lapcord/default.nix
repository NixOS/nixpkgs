{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Hyduez";
  name = "dou.lapcord";
  version = "2.0.1";
  hash = "sha256-jjtY9mKq5homhFZkw2XND5GGAxkH23HJZ4vaYHpHDvk=";
  meta = {
    description = "Discord Rich Presence extension for Lapce Editor.";
    homepage = "https://plugins.lapce.dev/plugins/Hyduez/dou.lapcord";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
