{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "panekj";
  name = "lapce-typescript";
  version = "2022.11.0";
  hash = "sha256-DChRrXfWSL1lynP7yhP4J+OMsr5A/tyWCv9FS/Ks0ew=";
  meta = {
    description = "Typescript & Javascript language support";
    homepage = "https://plugins.lapce.dev/plugins/panekj/lapce-typescript";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
