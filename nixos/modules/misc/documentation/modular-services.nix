/**
  Renders documentation for modular services.
  For inclusion into documentation.nixos.extraModules.
*/
{ lib, pkgs, ... }:
let
  /**
    Causes a modular service's docs to be rendered.
    This is an intermediate solution until we have "native" service docs in some nicer form.
  */
  fakeSubmodule =
    module:
    lib.mkOption {
      type = lib.types.submoduleWith {
        modules = [ module ];
      };
      description = "This is a [modular service](https://nixos.org/manual/nixos/unstable/#modular-services), which can be imported into a NixOS configuration using the [`system.services`](https://search.nixos.org/options?channel=unstable&show=system.services&query=modular+service) option.";
    };

  modularServicesModule = {
    _file = "${__curPos.file}:${toString __curPos.line}";
    options = {
      "<imports = [ pkgs.ghostunnel.services.default ]>" = fakeSubmodule pkgs.ghostunnel.services.default;
      "<imports = [ pkgs.php.services.default ]>" = fakeSubmodule pkgs.php.services.default;
    };
  };
in
{
  documentation.nixos.extraModules = [
    modularServicesModule
  ];
}
