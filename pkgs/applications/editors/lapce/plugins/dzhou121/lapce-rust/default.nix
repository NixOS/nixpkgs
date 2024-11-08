{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "dzhou121";
  name = "lapce-rust";
  version = "0.3.1932";
  hash = "sha256-LJ5tb37aIlTvbW5qCQBs9rOEV9M48BmzGsZD2J6WPw0=";
  meta = {
    description = "Rust for Lapce: powered by Rust Analyzer";
    homepage = "https://plugins.lapce.dev/plugins/dzhou121/lapce-rust";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
