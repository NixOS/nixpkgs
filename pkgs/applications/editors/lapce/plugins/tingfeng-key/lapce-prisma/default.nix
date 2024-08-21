{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "tingfeng-key";
  name = "lapce-prisma";
  version = "0.1.0";
  hash = "sha256-akbIqaKu9qA/+oPyBwLKY/gpEfG5IXNxr2W0bm2URdU=";
  meta = {
    description = "Prisma plugin for lapce";
    homepage = "https://plugins.lapce.dev/plugins/tingfeng-key/lapce-prisma";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
