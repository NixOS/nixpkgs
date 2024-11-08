{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "panekj";
  name = "lapce-terraform-ls";
  version = "0.0.2+terraform-ls.0.32.7";
  hash = "sha256-hKjT+as+XuXKmSwKsu2p4UdYhc71KojzhZMX/JNoQjw=";
  meta = {
    description = "Terraform support for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/panekj/lapce-terraform-ls";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
