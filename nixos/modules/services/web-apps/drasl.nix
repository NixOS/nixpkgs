{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.drasl;
  format = pkgs.formats.toml { };
  filterAttrs = x: lib.filterAttrs (n: v: n != "ClientSecretFile" || v != null) x;
  getIndex =
    item:
    builtins.toString (lib.lists.findFirstIndex (x: x == item) null cfg.settings.RegistrationOIDC);
  secretFiles = lib.filter (
    x: lib.hasAttr "ClientSecretFile" (filterAttrs x)
  ) cfg.settings.RegistrationOIDC;
  settings = format.generate "drasl-config.toml" (
    if cfg.settings.RegistrationOIDC == [ ] then
      lib.filterAttrs (n: v: n != "RegistrationOIDC" || v != [ ]) cfg.settings
    else
      lib.recursiveUpdate cfg.settings {
        RegistrationOIDC = map (
          x:
          if lib.hasAttr "ClientSecretFile" (filterAttrs x) then
            lib.recursiveUpdate (filterAttrs x) {
              ClientSecretFile = "$CREDENTIALS_DIRECTORY/${getIndex x}";
            }
          else
            filterAttrs x
        ) cfg.settings.RegistrationOIDC;
      }
  );
in
{
  options.services.drasl = {
    enable = lib.mkEnableOption "Drasl";
    package = lib.mkPackageOption pkgs "drasl" { };
    enableDebug = lib.mkEnableOption "debugging";
    settings = lib.mkOption {
      description = ''
        Configuration for Drasl. See the
        [Drasl documentation](https://github.com/unmojang/drasl/blob/master/doc/configuration.md)
        for possible options.
      '';
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          RegistrationOIDC = lib.mkOption {
            default = [ ];
            description = "List of OpenID connect providers.";
            type = lib.types.listOf (
              lib.types.submodule {
                freeformType = format.type;
                options = {
                  ClientSecretFile = lib.mkOption {
                    default = null;
                    description = ''
                      Path to a file containing the OIDC client secret.

                      ::: {.note}
                      The NixOS module will automatically load this file using
                      systemd's LoadCredential. Make sure this file is only
                      readable by the root user.
                      :::
                    '';
                    type = lib.types.nullOr lib.types.path;
                  };
                };
              }
            );
          };
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    warnings =
      let
        s = cfg.settings;
        oidcDepNames = map (e: e.Name or "<unnamed>") (
          lib.filter (e: e ? RequireInvite) (s.RegistrationOIDC or [ ])
        );
      in
      lib.optional (s ? ForwardSkins)
        "services.drasl.settings.ForwardSkins is deprecated: set ForwardSkins on individual FallbackAPIServers instead."
      ++
        lib.optional (s ? AllowAddingDeletingPlayers)
          "services.drasl.settings.AllowAddingDeletingPlayers is deprecated: now controlled by CreateNewPlayer.Allow and the presence of ImportExistingPlayer."
      ++
        lib.optional (s ? RegistrationNewPlayer)
          "services.drasl.settings.RegistrationNewPlayer is deprecated: use RegistrationUsernamePassword.CreateNewPlayer and RegistrationOIDC.CreateNewPlayer."
      ++
        lib.optional (s ? RegistrationExistingPlayer)
          "services.drasl.settings.RegistrationExistingPlayer is deprecated: use RegistrationUsernamePassword.ImportExistingPlayer and RegistrationOIDC.ImportExistingPlayer."
      ++
        lib.optional (s ? ImportExistingPlayer && !(lib.isList s.ImportExistingPlayer))
          "services.drasl.settings.ImportExistingPlayer is using the deprecated single-table [ImportExistingPlayer] form. Use [[ImportExistingPlayer]] with FallbackAPIServerNickname, and define the API server in [[FallbackAPIServers]]."
      ++
        lib.optional (oidcDepNames != [ ])
          "services.drasl.settings.RegistrationOIDC[].RequireInvite is deprecated for entries: ${lib.concatStringsSep ", " oidcDepNames}. Use RegistrationOIDC.CreateNewPlayer.RequireInvite and RegistrationOIDC.ImportExistingPlayer.RequireInvite.";
    assertions = [
      {
        assertion = lib.allUnique cfg.settings.RegistrationOIDC;
        message = "All items in `services.drasl.settings.RegistrationOIDC` must be unique.";
      }
      {
        assertion = lib.all (
          x: (lib.hasAttr "ClientSecretFile" (filterAttrs x)) -> !(lib.hasAttr "ClientSecret" (filterAttrs x))
        ) cfg.settings.RegistrationOIDC;
        message =
          "Do not set both `services.drasl.settings.RegistrationOIDC.*.ClientSecret` "
          + "and `services.drasl.settings.RegistrationOIDC.*.ClientSecretFile`";
      }
    ];
    systemd.services.drasl = {
      description = "Drasl";
      after = [
        "network-online.target"
        "nss-lookup.target"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = lib.mkIf cfg.enableDebug { DRASL_DEBUG = "1"; };
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -config ${settings}";
        DynamicUser = true;
        RuntimeDirectory = "drasl";
        RuntimeDirectoryMode = "0700";
        StateDirectory = "drasl";
        LoadCredential = lib.mkIf (secretFiles != [ ]) (
          map (x: "${getIndex x}:${x.ClientSecretFile}") secretFiles
        );
        # Hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        PrivateTmp = "disconnected";
        ProcSubset = "pid";
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = [
          "~cgroup"
          "~ipc"
          "~mnt"
          "~net"
          "~pid"
          "~user"
          "~uts"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@clock"
          "~@cpu-emulation"
          "~@debug"
          "~@module"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@raw-io"
          "~@reboot"
          "~@resources"
          "~@swap"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    evan-goode
    ungeskriptet
  ];
}
