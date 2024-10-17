{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "MathiasPius";
  name = "lapce-crates";
  version = "0.1.0";
  hash = "sha256-tyUn0a1FoRlMRYFPfSy7FzP2FFZ52s197kAma2rpgXA=";
  meta = {
    description = "Crates.io integration for Cargo.toml";
    homepage = "https://plugins.lapce.dev/plugins/MathiasPius/lapce-crates";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
