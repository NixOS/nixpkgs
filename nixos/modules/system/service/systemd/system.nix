{
  lib,
  config,
  options,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatMapAttrs
    mkOption
    types
    concatLists
    mapAttrsToList
    ;

  portable-lib = import ../portable/lib.nix { inherit lib; };

  dash =
    before: after:
    if after == "" then
      before
    else if before == "" then
      after
    else
      "${before}-${after}";

  makeNixosEtcFiles =
    prefix: service:
    let
      # Convert configData entries to environment.etc entries
      serviceConfigData = lib.mapAttrs' (name: cfg: {
        name =
          # cfg.path is read only and prefixed with unique service name; see ./config-data-path.nix
          assert lib.hasPrefix "/etc/system-services" cfg.path;
          lib.removePrefix "/etc/" cfg.path;
        value = {
          inherit (cfg) enable source;
        };
      }) (service.configData or { });

      # Recursively process sub-services
      subServiceConfigData = concatMapAttrs (
        subServiceName: subService: makeNixosEtcFiles (dash prefix subServiceName) subService
      ) service.services;
    in
    serviceConfigData // subServiceConfigData;

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
            ./config-data-path.nix

            # TODO: Consider removing pkgs. Service modules can provide their own
            #       dependencies.
            {
              # Extend portable services option
              options.services = lib.mkOption {
                type = types.attrsOf (
                  types.submoduleWith {
                    specialArgs.pkgs = pkgs;
                    modules = [ ];
                  }
                );
              };
            }
          ];
          specialArgs = {
            # perhaps: features."systemd" = { };
            # TODO: Consider removing pkgs. Service modules can provide their own
            #       dependencies.
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

    assertions = concatLists (
      mapAttrsToList (
        name: cfg: portable-lib.getAssertions (options.system.services.loc ++ [ name ]) cfg
      ) config.system.services
    );

    warnings = concatLists (
      mapAttrsToList (
        name: cfg: portable-lib.getWarnings (options.system.services.loc ++ [ name ]) cfg
      ) config.system.services
    );

    systemd.services = concatMapAttrs (
      serviceName: topLevelService: makeUnits "services" serviceName topLevelService
    ) config.system.services;

    systemd.sockets = concatMapAttrs (
      serviceName: topLevelService: makeUnits "sockets" serviceName topLevelService
    ) config.system.services;

    environment.etc = concatMapAttrs (
      serviceName: topLevelService: makeNixosEtcFiles serviceName topLevelService
    ) config.system.services;
  };
}
