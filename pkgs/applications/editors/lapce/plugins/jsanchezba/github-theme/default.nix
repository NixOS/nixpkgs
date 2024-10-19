{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "jsanchezba";
  name = "github-theme";
  version = "0.1.1";
  hash = "sha256-vHJSZ9x/vcIBlEzA/81RtAqdSCN20I/E618RmS476Os=";
  meta = {
    description = "GitHub Light Theme";
    homepage = "https://plugins.lapce.dev/plugins/jsanchezba/github-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
