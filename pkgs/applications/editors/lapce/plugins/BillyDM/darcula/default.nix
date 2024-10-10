{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "BillyDM";
  name = "darcula";
  version = "0.3.0";
  hash = "sha256-yJBmYBZYXpSMd25KpmovTay1p/teegwHxgqQ5FgWN0U=";
  meta = {
    description = "Darcula color theme";
    homepage = "https://plugins.lapce.dev/plugins/BillyDM/darcula";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
