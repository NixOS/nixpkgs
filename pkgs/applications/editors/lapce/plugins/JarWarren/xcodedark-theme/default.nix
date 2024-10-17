{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "JarWarren";
  name = "xcodedark-theme";
  version = "0.1.1";
  hash = "sha256-4U/QhsTzQAJCqabdezbl36ivrd0+l4rxUPH2b0C/AJ0=";
  meta = {
    description = "Xcode's \"Default (Dark)\" theme.";
    homepage = "https://plugins.lapce.dev/plugins/JarWarren/xcodedark-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
