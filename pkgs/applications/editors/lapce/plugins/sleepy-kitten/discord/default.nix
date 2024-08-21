{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "sleepy-kitten";
  name = "discord";
  version = "0.2.1";
  hash = "sha256-FepeooMjFgKonCcYtF5cPazWP4lEo4gEnIqUzU5tSxU=";
  meta = {
    description = "Discord like theme";
    homepage = "https://plugins.lapce.dev/plugins/sleepy-kitten/discord";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
