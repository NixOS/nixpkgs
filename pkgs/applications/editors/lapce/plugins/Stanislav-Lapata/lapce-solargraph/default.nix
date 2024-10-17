{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Stanislav-Lapata";
  name = "lapce-solargraph";
  version = "0.1.2";
  hash = "sha256-ogi8ZaMp0CYNUYFd91ykGsn/rEoTXSBgsZJni932p9I=";
  meta = {
    description = "Ruby plugin for the Lapce Editor - Powered by solargraph";
    homepage = "https://plugins.lapce.dev/plugins/Stanislav-Lapata/lapce-solargraph";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
