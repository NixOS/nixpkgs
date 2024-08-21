{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "d4rkr41n";
  name = "dracula";
  version = "0.1.0";
  hash = "sha256-25Suo8qjZjnZ2txsgLLokidZFZEYo7sjBL2ELYL87/Q=";
  meta = {
    description = "A dark theme for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/d4rkr41n/dracula";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
