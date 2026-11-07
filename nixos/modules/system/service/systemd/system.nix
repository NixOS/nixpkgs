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
    mkDefault
    mkIf
    mkMerge
    types
    concatLists
    mapAttrsToList
    ;

  portable-lib = lib.services;

  identity-lib = import ./identity.nix { inherit lib; };

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

  # Collect the resolved service identities into lists of NixOS users and
  # groups definitions. Identities are resolved per service by ./identity.nix;
  # services that inherit the identity of another service resolve to the same
  # user and their entries are merged by `mkMerge`.
  makeServiceIdentities =
    service:
    let
      identity = service.identity;
    in
    [
      {
        users =
          if identity.user == null || identity.user == "root" then
            { }
          else
            {
              "${identity.user}" = {
                description = mkDefault "Modular service user";
                isSystemUser = mkDefault true;
                group = mkDefault identity.group;
                uid = mkIf (identity.uid != null) (mkDefault identity.uid);
                extraGroups = mkIf (identity.groups != [ ]) (mkDefault identity.groups);
              };
            };

        groups =
          { }
          # The primary group. Skipped for root, whose group is already
          # declared by NixOS.
          // (
            if identity.user == "root" then
              { }
            else if identity.group == null then
              { }
            else
              {
                "${identity.group}" = {
                  gid = mkIf (identity.gid != null) (mkDefault identity.gid);
                };
              }
          )
          # Supplementary groups, with pinned gids where provided. `gids` is
          # extended with nulls so that a length mismatch is reported by the
          # `identity.gids` assertion instead of failing evaluation here.
          // (
            if identity.groups == null then
              { }
            else
              lib.listToAttrs (
                lib.imap0 (
                  i: group:
                  lib.nameValuePair group {
                    gid = mkIf (identity.gids != null && identity.gids != [ ]) (
                      mkDefault (lib.elemAt (identity.gids ++ lib.genList (_: null) (lib.length identity.groups)) i)
                    );
                  }
                ) identity.groups
              )
          );
      }
    ]
    ++ concatLists (mapAttrsToList (_: subService: makeServiceIdentities subService) service.services);

  # All service identity entries, one per service, recursively.
  allServiceIdentities = concatLists (
    mapAttrsToList (_: service: makeServiceIdentities service) config.system.services
  );

  modularServiceConfiguration = portable-lib.configure {
    serviceManagerPkgs = pkgs;
    extraRootModules = [
      ./service.nix
      ./config-data-path.nix
      # Resolves each service's identity, and injects the absoluteServicePath
      # service handles used by `identity.sameUser`.
      (identity-lib.mkIdentityModule {
        supported = true;
        path = [ ];
      })
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

    # Service users and groups, collected from the resolved service identities.
    users.users = mkMerge (map (i: i.users) allServiceIdentities);

    users.groups = mkMerge (map (i: i.groups) allServiceIdentities);
  };
}
