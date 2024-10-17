{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "panekj";
  name = "lapce-go";
  version = "2023.1.0";
  hash = "sha256-HZJW28ve7xLoNOBxKNfFnPWs/Prk+/znvUh8jI6YwMI=";
  meta = {
    description = "Go for Lapce using gopls";
    homepage = "https://plugins.lapce.dev/plugins/panekj/lapce-go";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
