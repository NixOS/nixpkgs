{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "joyme123";
  name = "thrift-ls";
  version = "0.0.3";
  hash = "sha256-XEfe7D/sKH5umJcDZ/JtCqniLAaWXNn0Ygbjp1Wmw24=";
  meta = {
    description = "thrift language server";
    homepage = "https://plugins.lapce.dev/plugins/joyme123/thrift-ls";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
