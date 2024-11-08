{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Stepland";
  name = "monokai-vscode";
  version = "1.0.0";
  hash = "sha256-NoalGt6R+gwPHTHEg35ppbM4u3aeyq9aaU6Mm2jwc78=";
  meta = {
    description = "Port of the Monokai theme from VSCode";
    homepage = "https://plugins.lapce.dev/plugins/Stepland/monokai-vscode";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
