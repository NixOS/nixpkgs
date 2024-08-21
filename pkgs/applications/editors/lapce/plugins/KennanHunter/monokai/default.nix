{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "KennanHunter";
  name = "monokai";
  version = "0.1.0";
  hash = "sha256-2wQ7sFBxWXgFhxWN6xkSRpNag4iJCNtIhbIqm97LIAI=";
  meta = {
    description = "The Classic Monokai Theme";
    homepage = "https://plugins.lapce.dev/plugins/KennanHunter/monokai";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
