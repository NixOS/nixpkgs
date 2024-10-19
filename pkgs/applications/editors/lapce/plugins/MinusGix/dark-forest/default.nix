{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "MinusGix";
  name = "dark-forest";
  version = "0.1.1";
  hash = "sha256-hYcz54F8ryq5m9drLAvYDPOhbZpOFL0CkZuQeebU26w=";
  meta = {
    description = "A dimly lit forest";
    homepage = "https://plugins.lapce.dev/plugins/MinusGix/dark-forest";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
