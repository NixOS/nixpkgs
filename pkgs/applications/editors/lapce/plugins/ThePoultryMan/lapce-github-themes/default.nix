{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ThePoultryMan";
  name = "lapce-github-themes";
  version = "0.1.0";
  hash = "sha256-8Bmxr7sKDiAVqqghJitoKtTRJJpWHT4RNRSeP1j9U6s=";
  meta = {
    description = "Various themes based off of GitHub's themes.";
    homepage = "https://plugins.lapce.dev/plugins/ThePoultryMan/lapce-github-themes";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
