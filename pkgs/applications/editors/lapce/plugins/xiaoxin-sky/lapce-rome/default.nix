{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "xiaoxin-sky";
  name = "lapce-rome";
  version = "0.0.1";
  hash = "sha256-fChbExavT24DVvtqQMmXdrlvqTUoaUb5WtQly82PSiY=";
  meta = {
    description = "a Faster(⚡)  formatter, linter, bundler, and more for JavaScript, TypeScript, JSON, HTML, Markdown, and CSS.";
    homepage = "https://plugins.lapce.dev/plugins/xiaoxin-sky/lapce-rome";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
