# Optional Modules {#ch-optional-modules}

## `noLegacyPkgs` {#sec-noLegacyPkgs}

This module reimplements `nixpkgs.*` without legacy options such as `nixpkgs.localSystem`.

When imported from the flake (experimental), this module will reuse `legacyPackages` when only `hostPlatform` is specified.

This module is ignored when [`readOnlyPkgs`](#sec-readOnlyPkgs) is imported.

Example use with a flake (experimental):

```nix
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    inputs.nixpkgs.nixosModules.noLegacyPkgs
    ./configuration.nix
  ];
}
```

```{=include=} options
id-prefix: module-noLegacyPkgs-opt-
list-id: module-noLegacyPkgs-options
source: @OPTIONS_JSON_noLegacyPkgs@
```

## `readOnlyPkgs` {#sec-readOnlyPkgs}

This module ensures that the `pkgs` module argument is as specified, manually.

The usual `nixpkgs.*` options are replaced by read-only options for compatibility. These are not listed here. NixOS modules should
get their information from the `pkgs` module argument and ignore `nixpkgs.*`.

Example use with a flake (experimental):

```nix
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    inputs.nixpkgs.nixosModules.readOnlyPkgs
    ./configuration.nix
    {
      nixpkgs.pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    }
  ];
}
```

```{=include=} options
id-prefix: module-readOnlyPkgs-opt-
list-id: module-readOnlyPkgs-options
source: @OPTIONS_JSON_readOnlyPkgs@
```
