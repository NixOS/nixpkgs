{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "brocococonut";
  name = "lapce-svelte";
  version = "0.1.0";
  hash = "sha256-XnvhI3FC3JpItPhF7cmpG6Hej/D1UZlW3xdbnz1cI0I=";
  meta = {
    description = "Svelte plugin for lapce";
    homepage = "https://plugins.lapce.dev/plugins/brocococonut/lapce-svelte";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
