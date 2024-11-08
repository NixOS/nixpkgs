{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "xiaoxin-sky";
  name = "lapce-vue";
  version = "0.0.2";
  hash = "sha256-vE+jAYMO2+F/XLJQBfFmlelLHS1VJsfFs1YBvbrHsxw=";
  meta = {
    description = "vue auto-complete,ts type-check,diagnosis";
    homepage = "https://plugins.lapce.dev/plugins/xiaoxin-sky/lapce-vue";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
