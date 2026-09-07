{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.flap-alerted;

  settingsArgs = lib.pipe cfg.settings [
    (lib.mapAttrsToList (
      name: value:
      if value == null || value == false then
        [ ]
      else if value == true then
        [ "-${name}" ]
      else
        [
          "-${name}"
          (toString value)
        ]
    ))
    lib.concatLists
  ];
in

{
  meta.maintainers = with lib.maintainers; [ defelo ];

  options.services.flap-alerted = {
    enable = lib.mkEnableOption "FlapAlerted";

    package = lib.mkPackageOption pkgs "flap-alerted" { };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/flap-alerted.env" ];
      description = ''
        Files to load environment variables from.
        This is useful to avoid putting secrets into the nix store.
        See <https://github.com/Kioubit/FlapAlerted> for a list of options.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        Extra command line arguments to pass to FlapAlerted.
        See <https://github.com/Kioubit/FlapAlerted> for a list of options.
      '';
      default = [ ];
    };

    settings = lib.mkOption {
      description = ''
        Configuration of FlapAlerted.
        See <https://github.com/Kioubit/FlapAlerted> for a list of options.
      '';
      default = { };

      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.int
              lib.types.bool
            ]
          )
        );

        options = {
          asn = lib.mkOption {
            type = lib.types.ints.u32;
            description = "Your ASN number";
          };

          bgpListenAddress = lib.mkOption {
            type = lib.types.str;
            description = "Address to listen on for incoming BGP connections";
            default = ":1790";
          };

          debug = lib.mkOption {
            type = lib.types.bool;
            description = "Enable debug mode (produces a lot of output)";
            default = false;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.flap-alerted = {
      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        User = "flap-alerted";
        Group = "flap-alerted";
        DynamicUser = true;

        EnvironmentFile = cfg.environmentFiles;

        ExecStart = lib.escapeShellArgs ([ (lib.getExe cfg.package) ] ++ settingsArgs ++ cfg.extraArgs);

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };
  };
}
