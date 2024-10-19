{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "CroxxN";
  name = "lapce-html";
  version = "0.0.1";
  hash = "sha256-/uazWNQ7mDWPsCAffChz2xyYiJXmKksGkBNiqXKroHg=";
  meta = {
    description = "HTML lsp for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/CroxxN/lapce-html";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
