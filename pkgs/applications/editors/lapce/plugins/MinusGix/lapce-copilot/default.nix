{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "MinusGix";
  name = "lapce-copilot";
  version = "1.0.1";
  hash = "sha256-+p0BGte0R9cZPNUIkDpItC3s8YZA50bq53Ydjth6n0U=";
  meta = {
    description = "Unofficial Github Copilot plugin";
    homepage = "https://plugins.lapce.dev/plugins/MinusGix/lapce-copilot";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
