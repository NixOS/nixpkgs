{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "vikaskaliramna";
  name = "lapce-deno";
  version = "0.0.0";
  hash = "sha256-+hu/qxytlyhAbSqGuDC/Qz53bqHSXhN0OAse+zGErAE=";
  meta = {
    description = "Deno";
    homepage = "https://plugins.lapce.dev/plugins/vikaskaliramna/lapce-deno";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
