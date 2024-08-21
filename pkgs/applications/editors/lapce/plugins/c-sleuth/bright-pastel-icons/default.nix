{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "c-sleuth";
  name = "bright-pastel-icons";
  version = "0.0.0";
  hash = "sha256-+v3cUgKrghxSjCNLgwuWRn/HSIhUu7ERhE8yIEyvz8A=";
  meta = {
    description = "Bright Pastel icon theme for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/c-sleuth/bright-pastel-icons";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
