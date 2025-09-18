{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    isBool
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mkRenamedOptionModule
    types
    ;

  cfg = config.services.redlib;

  args = concatStringsSep " " ([
    "--port ${toString cfg.port}"
    "--address ${cfg.address}"
  ]);

  boolToString' = b: if b then "on" else "off";
in
{
  imports = [
    (mkRenamedOptionModule
      [
        "services"
        "libreddit"
      ]
      [
        "services"
        "redlib"
      ]
    )
  ];

  options = {
    services.redlib = {
      enable = mkEnableOption "Private front-end for Reddit";

      package = mkPackageOption pkgs "redlib" { };

      address = mkOption {
        default = "0.0.0.0";
        example = "127.0.0.1";
        type = types.str;
        description = "The address to listen on";
      };

      port = mkOption {
        default = 8080;
        example = 8000;
        type = types.port;
        description = "The port to listen on";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the redlib web interface";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType =
            with types;
            attrsOf (
              nullOr (oneOf [
                bool
                int
                str
              ])
            );
          options = { };
        };
        default = { };
        description = ''
          See [GitHub](https://github.com/redlib-org/redlib/tree/main?tab=readme-ov-file#configuration) for available settings.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services.redlib = {
      wantedBy = [ "default.target" ];
      environment = mapAttrs (_: v: if isBool v then boolToString' v else toString v) cfg.settings;
      serviceConfig = {
        # Hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@mount"
          "~@swap"
          "~@resources"
          "~@reboot"
          "~@raw-io"
          "~@obsolete"
          "~@module"
          "~@debug"
          "~@cpu-emulation"
          "~@clock"
          "~@privileged"
        ];
        UMask = "0027";

        ExecStart = [
          ""
          "${lib.getExe cfg.package} ${args}"
        ];
      }
      // (
        if (cfg.port < 1024) then
          {
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
            CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          }
        else
          {
            # A private user cannot have process capabilities on the host's user
            # namespace and thus CAP_NET_BIND_SERVICE has no effect.
            PrivateUsers = true;
            CapabilityBoundingSet = false;
          }
      );
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ Guanran928 ];
  };
}
