{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "p-yukusai";
  name = "black-iris";
  version = "0.1.11";
  hash = "sha256-Olgf3dcDHwdr9HavrxyPAWTf8rRthpYIRCdaVV3lrWM=";
  meta = {
    description = "A dark theme with pastel colors";
    homepage = "https://plugins.lapce.dev/plugins/p-yukusai/black-iris";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
