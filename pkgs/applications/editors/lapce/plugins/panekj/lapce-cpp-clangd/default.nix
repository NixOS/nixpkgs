{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "panekj";
  name = "lapce-cpp-clangd";
  version = "2024.2.0";
  hash = "sha256-RHmJdyw7xj0AuDelcbKlmst05IVTMHSadR68porPGQU=";
  meta = {
    description = "C/C++ language support";
    homepage = "https://plugins.lapce.dev/plugins/panekj/lapce-cpp-clangd";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
