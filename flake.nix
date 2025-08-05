# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.
{
  description = "A collection of packages for the Nix package manager";

  outputs =
    { self }:
    let
      lib = import ./lib;

      flake = lib.evalModules {
        specialArgs = {
          inherit self;

          mkPerSystemOption = import ./flake/per-system.nix {
            inherit lib;
            return = "mkPerSystemOption";
          };
        };

        modules = [
          ./doc/flake-module.nix
          ./flake/checks.nix
          ./flake/dev-shell.nix
          ./flake/formatter.nix
          ./flake/outputs.nix
          ./flake/systems.nix
          ./lib/flake-module.nix
          ./nixos/flake-module.nix
          ./pkgs/top-level/flake-module.nix
          (lib.modules.importApply ./flake/per-system.nix {
            inherit lib;
            return = "module";
          })
        ];
      };
    in
    flake.config.outputs;
}
