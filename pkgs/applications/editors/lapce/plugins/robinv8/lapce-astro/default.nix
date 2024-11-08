{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "robinv8";
  name = "lapce-astro";
  version = "0.0.1";
  hash = "sha256-as92p0ZnBfdNPjKrzknaQx7Mj0W5IU2EZgER7rL+EiI=";
  meta = {
    description = "Astro language support for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/robinv8/lapce-astro";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
