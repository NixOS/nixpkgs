/**
  Renders documentation for modular services.
  For inclusion into documentation.nixos.extraModules.
*/
{ lib, ... }:
{
  options.documentation.nixos.bundledModularServiceNames = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    internal = true;
    default = builtins.attrNames (
      import ../../../../pkgs/top-level/modular-services-bundled.nix (
        throw "documentation.nixos.bundledModularServiceNames: pkgs must not be evaluated"
      )
    );
    description = "Names of bundled modular services to include in NixOS documentation.";
  };
}
