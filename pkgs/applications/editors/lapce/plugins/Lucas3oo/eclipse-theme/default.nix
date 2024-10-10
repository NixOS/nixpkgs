{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Lucas3oo";
  name = "eclipse-theme";
  version = "0.0.3";
  hash = "sha256-/CIXzGoudKs2fEumzBLlSppCx4edy42p0dQqm7I3ltc=";
  meta = {
    description = "Lapce theme similar to Eclipse light. Theme name: 'Eclipse Light'.";
    homepage = "https://plugins.lapce.dev/plugins/Lucas3oo/eclipse-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
