{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ghishadow";
  name = "lightpink";
  version = "0.2.8";
  hash = "sha256-oVZ+CRexvBlN1s1sDlAV2qoKFY4ZSmNbPhhqhNWz+M8=";
  meta = {
    description = "Cute Light Pink";
    homepage = "https://plugins.lapce.dev/plugins/ghishadow/lightpink";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
