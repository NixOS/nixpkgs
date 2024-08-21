{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "instance-id";
  name = "lapce-powershell";
  version = "0.0.1";
  hash = "sha256-gQttyneWYYolPnIrBHggbk2XZU9C4+l6SFqfR+rF5L0=";
  meta = {
    description = "PowerShell language support for Lapce provided by PowerShell Editor Services";
    homepage = "https://plugins.lapce.dev/plugins/instance-id/lapce-powershell";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
