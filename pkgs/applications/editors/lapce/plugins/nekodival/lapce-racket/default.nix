{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "nekodival";
  name = "lapce-racket";
  version = "0.0.1";
  hash = "sha256-2CJie32BY6pdbNi1D08u6nBmycOANexMGv4mEHqu9oA=";
  meta = {
    description = "Simple racket plugin for lapce";
    homepage = "https://plugins.lapce.dev/plugins/nekodival/lapce-racket";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
