# mergeNixOSModules {#sec-merge-nixos-modules}

Merge multiple NixOS modules and configuration files in to a single-file module.

This is for NixOS configuration files being written to servers during creation, intended for merging configuration snippets which describe the hardware properties of the host.
As a deployer it is nice to have a single file that you fetch from the remote to describe the host, especially when you're integrating with existing asset databases and tooling.

Note that each provided NixOS module must be self-contained and have no relative references.

Accepted arguments are:

- `name`
        Name of the resulting configuration file. Default: `configuration.nix`.
        Note the result of this builder will be a single-file output, ie: `/nix/store/<hash>-${name}`.
- `moduleFiles`
        A list of files containing NixOS modules to merge together.

## Example

```nix
# example.nix
let
  pkgs = import <nixpkgs> {};

  configA = pkgs.writeText "configA.nix" ''
    { config, pkgs, ... }: {
      services.configA.enable = true;
      environment.systemPackages = with pkgs; [ hello ];
    }
  '';

  configB = pkgs.writeText "configB.nix" ''
    {
      services.configB.enable = true;
    }
  '';
in
{
  myConfigFile = pkgs.mergeNixOSModules {
    name = "configuration.nix";
    moduleFiles = [ configA configB ];
  };
}
```

Running `nix-build ./example.nix -A myConfigFile` will produce a single file containing both configA and configB.
