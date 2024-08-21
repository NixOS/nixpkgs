{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "zarathir";
  name = "lapce-markdown";
  version = "0.3.2";
  hash = "sha256-+fn9enUr9y663m/3xloFau1yuJ34GDHDVWmOwYrSAbY=";
  meta = {
    description = "Markdown powered by Marksman";
    homepage = "https://plugins.lapce.dev/plugins/zarathir/lapce-markdown";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
