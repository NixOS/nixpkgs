{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Notiee";
  name = "forest-night-theme";
  version = "0.1.1";
  hash = "sha256-G0/L20thvMn9fXBMp7VW5Ci0SJKDb2YNan2rtA4FBAw=";
  meta = {
    description = "A true black theme with tasteful forest green accents.";
    homepage = "https://plugins.lapce.dev/plugins/Notiee/forest-night-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
