{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "elo1lson";
  name = "lapce-css";
  version = "0.0.2";
  hash = "sha256-zqYxsS4Eyd40sp2jrDfAK2j8tJ0o4YVSjY429UTjbSQ=";
  meta = {
    description = "Adds CSS and SCSS support";
    homepage = "https://plugins.lapce.dev/plugins/elo1lson/lapce-css";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
