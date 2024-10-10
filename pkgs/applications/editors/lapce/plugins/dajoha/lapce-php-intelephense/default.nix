{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "dajoha";
  name = "lapce-php-intelephense";
  version = "0.1.0";
  hash = "sha256-j3yaijcIbVx28kjHJQSEsTPlu3lgS0uomu9mfvy0/Qw=";
  meta = {
    description = "Php for Lapce using Intelephense";
    homepage = "https://plugins.lapce.dev/plugins/dajoha/lapce-php-intelephense";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
