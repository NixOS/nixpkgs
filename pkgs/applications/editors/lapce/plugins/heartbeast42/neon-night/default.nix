{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "heartbeast42";
  name = "neon-night";
  version = "0.1.0";
  hash = "sha256-jTccfuX6uzi/1CI6Ml5Wnp9SY7cJSktTD9nGtirfpaU=";
  meta = {
    description = "Dark Neon theme inspired by the cyberpunk aesthetic and genera, hints of vapor-wave and notes of the 80's";
    homepage = "https://plugins.lapce.dev/plugins/heartbeast42/neon-night";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
