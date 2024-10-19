{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Codextor";
  name = "material-theme";
  version = "1.2.0";
  hash = "sha256-qHE80Ickzm6qZcuMVb91BIvsRT7sivz34uByILdf1iY=";
  meta = {
    description = "Material Theme for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/Codextor/material-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
