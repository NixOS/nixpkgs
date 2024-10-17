{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Incognitux";
  name = "everblush";
  version = "0.1.0";
  hash = "sha256-b2BCnJT6MAzZhpmcjtHaqLxjU8aw25FfyRy7w/o7NWI=";
  meta = {
    description = "A Dark, Vibrant and Beatiful colorscheme";
    homepage = "https://plugins.lapce.dev/plugins/Incognitux/everblush";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
