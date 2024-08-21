{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "superlou";
  name = "lapce-python";
  version = "0.3.4";
  hash = "sha256-YJyuSr2csIOVqW7pEbp2tmnSFioi+fXA4U/8JZPqWf0=";
  meta = {
    description = "Python for Lapce using python-lsp-server";
    homepage = "https://plugins.lapce.dev/plugins/superlou/lapce-python";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
