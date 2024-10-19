{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "panekj";
  name = "vscode-themes";
  version = "2022.11.0";
  hash = "sha256-ZwCc8KtdgSiovy92c3yr1/tWGitiq9PJblT89TBz+ek=";
  meta = {
    description = "Default dark/light theme used in VS Code";
    homepage = "https://plugins.lapce.dev/plugins/panekj/vscode-themes";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
