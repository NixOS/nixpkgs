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

  portable-lib = import ../../../../../../lib/services/lib.nix { inherit lib; };

  dash =
    before: after:
    if after == "" then
      before
    else if before == "" then
      after
    else
      "${before}-${after}";

  mkConfiguration =
    userName:
    portable-lib.configure {
      serviceManagerPkgs = pkgs;
      extraRootModules = [
        ../service.nix
        (import ./config-data-path.nix userName)
        ./defaults.nix
      ];
      extraRootSpecialArgs = {
        systemdPackage = config.systemd.package;
      };
    };

  # Like system/default.nix's makeUnits, but prefixes with "${userName}--" and
  # suppresses WantedBy= on services (auto-start is wired per-user via the profile package).
  makeUnits =
    userName: unitType: prefix: service:
    concatMapAttrs (unitName: unitModule: {
      "${userName}--${dash prefix unitName}" =
        { ... }:
        {
          imports = [ unitModule ];
        }
        // lib.optionalAttrs (unitType == "services") {
          wantedBy = lib.mkForce [ ];
        };
    }) service.systemd.${unitType}
    // concatMapAttrs (
      subServiceName: subService: makeUnits userName unitType (dash prefix subServiceName) subService
    ) service.services;

  # Collect (globalName -> localName) pairs for all service units in the tree,
  # used to build the per-user profile package symlinks.
  collectServiceNames =
    userName: prefix: service:
    lib.mapAttrs' (
      unitName: _: lib.nameValuePair "${userName}--${dash prefix unitName}" (dash prefix unitName)
    ) service.systemd.services
    // concatMapAttrs (
      subServiceName: subService: collectServiceNames userName (dash prefix subServiceName) subService
    ) service.services;

  makeEtcLinks =
    prefix: service:
    lib.mapAttrsToList (
      _: cfg:
      let
        # cfg.path is e.g. /etc/profiles/per-user/alice/etc/xdg/user-services/foo/item
        # Strip the leading /etc/profiles/per-user/<user>/ to get the within-profile path.
        stripped = lib.removePrefix "/etc/profiles/per-user/" cfg.path;
        perUserPath = lib.concatStringsSep "/" (lib.tail (lib.splitString "/" stripped));
      in
      lib.optionalAttrs cfg.enable { "${perUserPath}" = cfg.source; }
    ) (service.configData or { })
    ++ concatLists (
      mapAttrsToList (
        subServiceName: subService: makeEtcLinks (dash prefix subServiceName) subService
      ) service.services
    );

  # Build the per-user profile package containing unit symlinks and configData.
  # `user` is the user submodule config; `config.systemd.user.units` is the outer NixOS
  # config, closed over from the module arguments above.
  makeUserPkg =
    userName: user:
    let
      allNames = concatMapAttrs (
        serviceName: service: collectServiceNames userName serviceName service
      ) user.services;

      etcLinks = lib.foldl' (acc: m: acc // m) { } (
        concatLists (mapAttrsToList (serviceName: service: makeEtcLinks serviceName service) user.services)
      );

      unitSymlinks = lib.concatMapAttrs (
        globalName: localName:
        let
          unitDrv = config.systemd.user.units."${globalName}.service".unit;
        in
        {
          "share/systemd/user/${localName}.service" = "${unitDrv}/${globalName}.service";
          "share/systemd/user/default.target.wants/${localName}.service" = "../${localName}.service";
        }
      ) allNames;
    in
    pkgs.runCommand "user-services-${userName}" { preferLocalBuild = true; } ''
      ${lib.concatStringsSep "\n" (
        mapAttrsToList (dest: src: ''
          mkdir -p "$out/$(dirname "${dest}")"
          ln -s ${lib.escapeShellArg src} "$out/${dest}"
        '') (unitSymlinks // etcLinks)
      )}
    '';
in
{
  _class = "nixos";

  # First half of the magic: mix systemd logic into the otherwise abstract services
  options = {
    users.users = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, config, ... }:
          {
            options.services = mkOption {
              description = ''
                A collection of [modular services](https://nixos.org/manual/nixos/unstable/#modular-services)
                that are configured as per-user systemd user units.
              '';
              type = types.attrsOf (mkConfiguration name).serviceSubmodule;
              default = { };
              visible = "shallow";
            };

            config.packages = lib.mkIf (config.services != { }) [
              (makeUserPkg name config)
            ];
          }
        )
      );
    };
  };

  # Second half of the magic: siphon units that were defined in isolation to the system
  config = {

    assertions = concatLists (
      mapAttrsToList (
        userName: user:
        concatLists (
          mapAttrsToList (
            serviceName: cfg:
            portable-lib.getAssertions (
              options.users.users.loc
              ++ [
                userName
                "services"
                serviceName
              ]
            ) cfg
          ) user.services
        )
      ) config.users.users
    );

    warnings = concatLists (
      mapAttrsToList (
        userName: user:
        concatLists (
          mapAttrsToList (
            serviceName: cfg:
            portable-lib.getWarnings (
              options.users.users.loc
              ++ [
                userName
                "services"
                serviceName
              ]
            ) cfg
          ) user.services
        )
      ) config.users.users
    );

    systemd.user.services = concatMapAttrs (
      userName: user:
      concatMapAttrs (
        serviceName: topLevelService: makeUnits userName "services" serviceName topLevelService
      ) user.services
    ) config.users.users;

    systemd.user.sockets = concatMapAttrs (
      userName: user:
      concatMapAttrs (
        serviceName: topLevelService: makeUnits userName "sockets" serviceName topLevelService
      ) user.services
    ) config.users.users;
  };
}
