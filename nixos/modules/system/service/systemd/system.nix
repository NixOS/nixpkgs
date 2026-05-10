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

  portable-lib = import ../../../../../lib/services/lib.nix { inherit lib; };

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

  configDataSources =
    service:
    lib.mapAttrsToList (_: cfg: cfg.source) (
      lib.filterAttrs (_: cfg: cfg.enable) (service.configData or { })
    );

  makeUnits =
    unitType: prefix: service:
    concatMapAttrs (
      unitName: unitModule:
      let
        sources = configDataSources service;
        extra = lib.optional (unitType == "services" && unitName == "" && sources != [ ]) (
          { config, ... }:
          {
            # switch-to-configuration-ng does not fall back from reload to restart:
            # X-Reload-Triggers on a unit without ExecReload= causes activation to
            # exit with code 4. Use reloadTriggers only when ExecReload is declared.
            reloadTriggers = lib.mkIf ((config.serviceConfig.ExecReload or null) != null) sources;
            restartTriggers = lib.mkIf ((config.serviceConfig.ExecReload or null) == null) sources;
          }
        );
      in
      {
        "${dash prefix unitName}" =
          { ... }:
          {
            imports = [ unitModule ] ++ extra;
          };
      }
    ) service.systemd.${unitType}
    // concatMapAttrs (
      subServiceName: subService: makeUnits unitType (dash prefix subServiceName) subService
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
