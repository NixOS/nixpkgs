{ mkDprintPlugin }:
mkDprintPlugin {
  description = "HTML, Vue, Svelte, Astro, Angular, Jinja, Twig, Nunjucks, and Vento formatter.";
  hash = "sha256-G8UnJbc+oZ60V3oi8W2SS6H06zEYfY3wpmSUp+1GF8k=";
  initConfig = {
    configExcludes = [ ];
    configKey = "markup";
    fileExtensions = [
      "html"
      "vue"
      "svelte"
      "astro"
      "jinja"
      "jinja2"
      "twig"
      "njk"
      "vto"
    ];
  };
  pname = "g-plane-markup_fmt";
  updateUrl = "https://plugins.dprint.dev/g-plane/markup_fmt/latest.json";
  url = "https://plugins.dprint.dev/g-plane/markup_fmt-v0.18.0.wasm";
  version = "0.18.0";
}
