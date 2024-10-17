{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "lotosbin";
  name = "guose";
  version = "0.0.2";
  hash = "sha256-pER+Jk1kc1EFseaHV7umqZFjDZ4A+qXuEXy3opBV558=";
  meta = {
    description = "China Color Theme";
    homepage = "https://plugins.lapce.dev/plugins/lotosbin/guose";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
