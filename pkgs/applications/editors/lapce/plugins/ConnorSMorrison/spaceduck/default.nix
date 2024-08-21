{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ConnorSMorrison";
  name = "spaceduck";
  version = "0.0.1";
  hash = "sha256-HjtzZSC161c9EH7sCogzphXMuH1VGTt1rODp0UC9Dh4=";
  meta = {
    description = "Lapce theme of Spaceduck";
    homepage = "https://plugins.lapce.dev/plugins/ConnorSMorrison/spaceduck";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
