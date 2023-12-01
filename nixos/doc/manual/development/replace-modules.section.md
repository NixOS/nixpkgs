# Replace Modules {#sec-replace-modules}

Modules that are imported can also be disabled. The option declarations,
config implementation and the imports of a disabled module will be
ignored, allowing another to take its place. This can be used to
import a set of modules from another channel while keeping the rest of
the system on a stable release.

`disabledModules` is a top level attribute like `imports`, `options` and
`config`. It contains a list of modules that will be disabled. This can
either be:
 - the full path to the module,
 - or a string with the filename relative to the modules path (eg. \<nixpkgs/nixos/modules> for nixos),
 - or an attribute set containing a specific `key` attribute.

The latter allows some modules to be disabled, despite them being distributed
via attributes instead of file paths. The `key` should be globally unique, so
it is recommended to include a file path in it, or rely on a framework to do it
for you.

This example will replace the existing postgresql module with the
version defined in the nixos-unstable channel while keeping the rest of
the modules and packages from the original nixos channel. This only
overrides the module definition, this won't use postgresql from
nixos-unstable unless explicitly configured to do so.

```nix
{ config, lib, pkgs, ... }:

{
  disabledModules = [ "services/databases/postgresql.nix" ];

  imports =
    [ # Use postgresql service from nixos-unstable channel.
      # sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
      <nixos-unstable/nixos/modules/services/databases/postgresql.nix>
    ];

  services.postgresql.enable = true;
}
```

This example shows how to define a custom module as a replacement for an
existing module. Importing this module will disable the original module
without having to know its implementation details.

```nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.man;
in

{
  disabledModules = [ "services/programs/man.nix" ];

  options = {
    programs.man.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable manual pages.";
    };
  };

  config = mkIf cfg.enabled {
    warnings = [ "disabled manpages for production deployments." ];
  };
}
```
