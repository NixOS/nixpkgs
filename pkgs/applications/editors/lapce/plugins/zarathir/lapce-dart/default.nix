{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "zarathir";
  name = "lapce-dart";
  version = "0.3.0";
  hash = "sha256-XFWBOURWxso4d8sq9Bruh7i5bT5qrSJXr9Qz9AX8GOs=";
  meta = {
    description = "Dart for Lapce: powered by dart language-server";
    homepage = "https://plugins.lapce.dev/plugins/zarathir/lapce-dart";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
