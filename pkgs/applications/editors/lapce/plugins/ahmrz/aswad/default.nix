{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ahmrz";
  name = "aswad";
  version = "0.3.0";
  hash = "sha256-E3CwLOOKkFBzbgFHq1ANs35vsbL3XkuZRZvDvEtZXDA=";
  meta = {
    description = "A dark theme for Lapce Editor";
    homepage = "https://plugins.lapce.dev/plugins/ahmrz/aswad";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
