{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) concatMapAttrs mkOption types;

  dash =
    before: after:
    if after == "" then
      before
    else if before == "" then
      after
    else
      "${before}-${after}";

  makeUnits =
    unitType: prefix: service:
    concatMapAttrs (unitName: unitModule: {
      "${dash prefix unitName}" =
        { ... }:
        {
          imports = [ unitModule ];
        };
    }) service.systemd.${unitType}
    // concatMapAttrs (
      subServiceName: subService: makeUnits unitType (dash prefix subServiceName) subService
    ) service.services;
in
{
  # First half of the magic: mix systemd logic into the otherwise abstract services
  options = {
    system.services = mkOption {
      description = ''
        A collection of NixOS [modular services](https://nixos.org/manual/nixos/unstable/#modular-services) that are configured as systemd services.
      '';
      type = types.attrsOf (
        types.submoduleWith {
          class = "service";
          modules = [
            ./service.nix
          ];
          specialArgs = {
            # perhaps: features."systemd" = { };
            inherit pkgs;
            systemdPackage = config.systemd.package;
          };
        }
      );
      default = { };
      visible = "shallow";
    };
  };

  # Second half of the magic: siphon units that were defined in isolation to the system
  config = {
    systemd.services = concatMapAttrs (
      serviceName: topLevelService: makeUnits "services" serviceName topLevelService
    ) config.system.services;

    systemd.sockets = concatMapAttrs (
      serviceName: topLevelService: makeUnits "sockets" serviceName topLevelService
    ) config.system.services;
  };
}
