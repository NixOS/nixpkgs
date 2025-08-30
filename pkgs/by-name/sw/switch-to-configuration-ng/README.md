# switch-to-configuration-ng

This program implements the switching/updating of NixOS systems. It starts with the existing running configuration at `/run/current-system` and handles the migration to a new configuration, built from a NixOS configuration's `config.system.build.toplevel` derivation.

For more information on what happens during a switch, see [what-happens-during-a-system-switch](../../../../nixos/doc/manual/development/what-happens-during-a-system-switch.chapter.md).

## Build in a devshell

```
cd ./pkgs/by-name/sw/switch-to-configuration-ng
nix-shell ../../../.. -A switch-to-configuration-ng
cd ./src
cargo build
```
