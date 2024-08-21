{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ItzSwirlz";
  name = "nord-theme";
  version = "0.1.1";
  hash = "sha256-9iCJQlhfhiPAyxp+duPRYbhKl5hmJP4V+xEgZ9BBBZA=";
  meta = {
    description = "An arctic, north-bluish color palette.";
    homepage = "https://plugins.lapce.dev/plugins/ItzSwirlz/nord-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
