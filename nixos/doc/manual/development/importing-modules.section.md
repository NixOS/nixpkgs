# Importing Modules {#sec-importing-modules}

Sometimes NixOS modules need to be used in configuration but exist
outside of Nixpkgs. These modules can be imported:

```nix
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Use a locally-available module definition in
      # ./example-module/default.nix
        ./example-module
    ];

  services.exampleModule.enable = true;
}
```

The environment variable `NIXOS_EXTRA_MODULE_PATH` is an absolute path
to a NixOS module that is included alongside the Nixpkgs NixOS modules.
Like any NixOS module, this module can import additional modules:

```nix
# ./module-list/default.nix
[
  ./example-module1
  ./example-module2
]
```

```nix
# ./extra-module/default.nix
{ imports = import ./module-list.nix; }
```

```nix
# NIXOS_EXTRA_MODULE_PATH=/absolute/path/to/extra-module
{ config, lib, pkgs, ... }:

{
  # No `imports` needed

  services.exampleModule1.enable = true;
}
```
