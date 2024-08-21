{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "JarWarren";
  name = "xcodelight-theme";
  version = "0.1.2";
  hash = "sha256-AiLxEJNLlrKiKcjyiGYSAlmktZUsYiPY1R2HnL56Ruk=";
  meta = {
    description = "Xcode's \"Default (Light)\" theme.";
    homepage = "https://plugins.lapce.dev/plugins/JarWarren/xcodelight-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
