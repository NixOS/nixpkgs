{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ghishadow";
  name = "kanagawa";
  version = "0.0.6";
  hash = "sha256-LdNSPVF7tG4EbN50yU4yKENO6wPWkg9Y7qv7pcZoKSQ=";
  meta = {
    description = "dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai. (based on Neovim theme)";
    homepage = "https://plugins.lapce.dev/plugins/ghishadow/kanagawa";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
