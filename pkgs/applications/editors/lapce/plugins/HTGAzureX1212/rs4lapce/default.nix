{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "HTGAzureX1212";
  name = "rs4lapce";
  version = "0.2.0";
  hash = "sha256-DzvI540fYBoiibdhZWlhbbxJJnN2z9NQSVLR06druCA=";
  meta = {
    description = "Rust plugin for Lapce, powered by Rust Analyzer";
    homepage = "https://plugins.lapce.dev/plugins/HTGAzureX1212/rs4lapce";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
