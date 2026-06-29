{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatMapAttrs
    concatLists
    filter
    mapAttrsToList
    mkOption
    optionalString
    types
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

  # Per-user service configuration factory (bakes userName into configData paths).
  mkConfiguration =
    userName:
    portable-lib.configure {
      serviceManagerPkgs = pkgs;
      extraRootModules = [
        ./service.nix
        (import ./user-config-data-path.nix userName)
        ./user-defaults.nix
      ];
      extraRootSpecialArgs = {
        systemdPackage = config.systemd.package;
      };
    };

  # Wrap service deferredModules for systemd.user.services with a per-user prefix.
  # wantedBy is forced to [] so the global unit file does not create /etc/systemd/user
  # wants symlinks that would auto-start the unit for every user.
  # The activation script creates per-user ~/.config/systemd/user/.wants symlinks instead.
  makeServiceUnitsForUser =
    userName: prefix: service:
    concatMapAttrs (unitName: unitModule: {
      "${userName}--${dash prefix unitName}" =
        { ... }:
        {
          imports = [ unitModule ];
          wantedBy = lib.mkForce [ ];
        };
    }) service.systemd.services
    // concatMapAttrs (
      subName: subSvc: makeServiceUnitsForUser userName (dash prefix subName) subSvc
    ) service.services;

  makeSocketUnitsForUser =
    userName: prefix: service:
    concatMapAttrs (unitName: unitModule: {
      "${userName}--${dash prefix unitName}" =
        { ... }:
        {
          imports = [ unitModule ];
        };
    }) service.systemd.sockets
    // concatMapAttrs (
      subName: subSvc: makeSocketUnitsForUser userName (dash prefix subName) subSvc
    ) service.services;

  # Returns an attrset mapping global unit name (alice--foo) to user-visible name (foo).
  collectServiceNames =
    userName: prefix: service:
    lib.mapAttrs' (
      unitName: _: lib.nameValuePair "${userName}--${dash prefix unitName}" (dash prefix unitName)
    ) service.systemd.services
    // concatMapAttrs (
      subName: subSvc: collectServiceNames userName (dash prefix subName) subSvc
    ) service.services;

  collectSocketNames =
    userName: prefix: service:
    lib.mapAttrs' (
      unitName: _: lib.nameValuePair "${userName}--${dash prefix unitName}" (dash prefix unitName)
    ) service.systemd.sockets
    // concatMapAttrs (
      subName: subSvc: collectSocketNames userName (dash prefix subName) subSvc
    ) service.services;

  # Convert configData entries to environment.etc entries rooted under
  # /etc/per-user-services/${userName}/.
  makeUserEtcFiles =
    userName: prefix: service:
    let
      serviceConfigData = lib.mapAttrs' (name: cfg: {
        name =
          assert lib.hasPrefix "/etc/per-user-services/${userName}" cfg.path;
          lib.removePrefix "/etc/" cfg.path;
        value = {
          inherit (cfg) enable source;
        };
      }) (service.configData or { });

      subServiceConfigData = concatMapAttrs (
        subName: subSvc: makeUserEtcFiles userName (dash prefix subName) subSvc
      ) service.services;
    in
    serviceConfigData // subServiceConfigData;

  # Generate the activation script fragment for a single user.
  mkUserActivation =
    userName: u:
    let
      svcPairs = concatMapAttrs (svcName: svc: collectServiceNames userName svcName svc) u.services;
      sockPairs = concatMapAttrs (svcName: svc: collectSocketNames userName svcName svc) u.services;
    in
    optionalString (u.services != { }) ''
      ${lib.escapeShellArg userName})
        mkdir -p "$HOME/.config/systemd/user/default.target.wants"
        # Remove stale managed service symlinks (point to /etc/systemd/user/${userName}--*)
        for _f in "$HOME/.config/systemd/user"/*.service "$HOME/.config/systemd/user"/*.socket; do
          [ -L "$_f" ] || continue
          case "$(readlink "$_f")" in
            /etc/systemd/user/${lib.escapeShellArg userName}--*) rm -f "$_f" ;;
          esac
        done
        # Remove stale relative .wants symlinks created by previous activations
        for _f in "$HOME/.config/systemd/user/default.target.wants"/*.service; do
          [ -L "$_f" ] || continue
          case "$(readlink "$_f")" in
            ../*.service) rm -f "$_f" ;;
          esac
        done
        ${lib.concatStrings (
          mapAttrsToList (globalName: userUnitName: ''
            ln -sfn "/etc/systemd/user/${globalName}.service" \
              "$HOME/.config/systemd/user/${userUnitName}.service"
            ln -sfn "../${userUnitName}.service" \
              "$HOME/.config/systemd/user/default.target.wants/${userUnitName}.service"
          '') svcPairs
        )}
        ${lib.concatStrings (
          mapAttrsToList (globalName: userUnitName: ''
            ln -sfn "/etc/systemd/user/${globalName}.socket" \
              "$HOME/.config/systemd/user/${userUnitName}.socket"
          '') sockPairs
        )}
        systemctl --user daemon-reload 2>/dev/null || true
        ;;
    '';

  userCases = mapAttrsToList mkUserActivation config.users.users;
  nonEmptyUserCases = filter (s: s != "") userCases;
in
{
  _class = "nixos";

  options.users.users = mkOption {
    type = types.attrsOf (
      types.submodule (
        { name, ... }:
        {
          options.services = mkOption {
            type = types.attrsOf (mkConfiguration name).serviceSubmodule;
            default = { };
            visible = "shallow";
            description = "Per-user [modular services](https://nixos.org/manual/nixos/unstable/#modular-services) realized as systemd --user units.";
          };
        }
      )
    );
  };

  config = {
    assertions = concatLists (
      mapAttrsToList (
        userName: u:
        concatLists (
          mapAttrsToList (
            svcName: cfg:
            portable-lib.getAssertions [
              "users"
              "users"
              userName
              "services"
              svcName
            ] cfg
          ) u.services
        )
      ) config.users.users
    );

    warnings = concatLists (
      mapAttrsToList (
        userName: u:
        concatLists (
          mapAttrsToList (
            svcName: cfg:
            portable-lib.getWarnings [
              "users"
              "users"
              userName
              "services"
              svcName
            ] cfg
          ) u.services
        )
      ) config.users.users
    );

    systemd.user.services = concatMapAttrs (
      userName: u: concatMapAttrs (svcName: svc: makeServiceUnitsForUser userName svcName svc) u.services
    ) config.users.users;

    systemd.user.sockets = concatMapAttrs (
      userName: u: concatMapAttrs (svcName: svc: makeSocketUnitsForUser userName svcName svc) u.services
    ) config.users.users;

    environment.etc = concatMapAttrs (
      userName: u: concatMapAttrs (svcName: svc: makeUserEtcFiles userName svcName svc) u.services
    ) config.users.users;

    system.userActivationScripts.modularUserServices = optionalString (nonEmptyUserCases != [ ]) (
      "case \"$USER\" in\n" + lib.concatStrings nonEmptyUserCases + "esac\n"
    );
  };
}
