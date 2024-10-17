{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ItzSwirlz";
  name = "aura-theme";
  version = "0.1.0";
  hash = "sha256-n44Ap5s0tmM0Ouf0VUm8IMLOboayLSFnpps9jmUjoFU=";
  meta = {
    description = "A beautiful dark theme for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/ItzSwirlz/aura-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
