{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "MrFoxPro";
  name = "lapce-nix";
  version = "0.0.1";
  hash = "sha256-n+j8p6sB/Bxdp0iY6Gty9Zkpv9Rg34HjKsT1gUuGDzQ=";
  meta = {
    description = "Plugin for oxalica/nil: Nix Language server, an incremental analysis assistent for writing in Nix.";
    homepage = "https://plugins.lapce.dev/plugins/MrFoxPro/lapce-nix";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
