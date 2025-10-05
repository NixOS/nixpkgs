# treefmt {#treefmt}

[treefmt](https://github.com/numtide/treefmt) streamlines the process of applying formatters to your project, making it a breeze with just one command line.

The [`treefmt` package](https://search.nixos.org/packages?channel=unstable&show=treefmt)
provides functions for configuring treefmt using the module system, which are [documented below](#sec-functions-library-treefmt), along with [their options](#sec-treefmt-options-reference).

Alternatively, treefmt can be configured using [treefmt-nix](https://github.com/numtide/treefmt-nix).

```{=include=} sections auto-id-prefix=auto-generated-treefmt-functions
treefmt-functions.section.md
```

## Options Reference {#sec-treefmt-options-reference}

The following attributes can be passed to [`withConfig`](#pkgs.treefmt.withConfig) or [`evalConfig`](#pkgs.treefmt.evalConfig):

```{=include=} options
id-prefix: opt-treefmt-
list-id: configuration-variable-list
source: ../treefmt-options.json
```

