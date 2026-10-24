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

  portable-lib = lib.services;

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
    if !service.enable then
      { }
    else
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

  # Maps the abstract dependency graph to absolute systemd unit names.
  # Dependency names in `service.dependencies.*` refer to sibling services at
  # the same nesting level. `parentPrefix` is the absolute name of the level
  # above the current service ("" for top-level services), so a sibling `foo`
  # becomes `dash parentPrefix foo`.
  unitOrder = parentPrefix: service: {
    unitConfig = {
      After = lib.mkDefault (map (name: "${dash parentPrefix name}.service") service.dependencies.after);
      Before = lib.mkDefault (
        map (name: "${dash parentPrefix name}.service") service.dependencies.before
      );
      Requires = lib.mkDefault (
        map (name: "${dash parentPrefix name}.service") service.dependencies.requires
      );
      Wants = lib.mkDefault (map (name: "${dash parentPrefix name}.service") service.dependencies.wants);
    };
  };

  makeUnits =
    unitType: prefix: parentPrefix: service:
    if !service.enable then
      { }
    else
      concatMapAttrs (unitName: unitModule: {
        "${dash prefix unitName}" =
          { ... }:
          {
            imports = [ unitModule ];
          }
          // lib.optionalAttrs (unitName == "") (unitOrder parentPrefix service);
      }) service.systemd.${unitType}
      // concatMapAttrs (
        subServiceName: subService: makeUnits unitType (dash prefix subServiceName) prefix subService
      ) service.services;

  modularServiceConfiguration = portable-lib.configure {
    serviceManagerPkgs = pkgs;
    extraRootModules = [
      ./service.nix
      ./config-data-path.nix
    ];
    extraRootSpecialArgs = {
      systemdPackage = config.systemd.package;
    };
  };
in
{
  _class = "nixos";

  # First half of the magic: mix systemd logic into the otherwise abstract services
  options = {
    system.services = mkOption {
      description = ''
        A collection of NixOS [modular services](https://nixos.org/manual/nixos/unstable/#modular-services) that are configured as systemd services.
      '';
      type = types.attrsOf modularServiceConfiguration.serviceSubmodule;
      default = { };
      visible = "shallow";
    };
  };

  # Second half of the magic: siphon units that were defined in isolation to the system
  config = lib.mkIf (config.system.initSystem == "systemd") {

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
      serviceName: topLevelService: makeUnits "services" serviceName "" topLevelService
    ) config.system.services;

    systemd.sockets = concatMapAttrs (
      serviceName: topLevelService: makeUnits "sockets" serviceName "" topLevelService
    ) config.system.services;

    environment.etc = concatMapAttrs (
      serviceName: topLevelService: makeNixosEtcFiles serviceName topLevelService
    ) config.system.services;
  };
}
