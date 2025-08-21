# Kakoune {#sec-kakoune}

Kakoune can be built to autoload plugins:

```nix
(kakoune.override { plugins = with pkgs.kakounePlugins; [ parinfer-rust ]; })
```
