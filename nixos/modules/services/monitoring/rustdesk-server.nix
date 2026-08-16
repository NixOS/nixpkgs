{
  lib,
  pkgs,
  config,
  ...
}:
let
  TCPPorts = [
    21115
    21116
    21117
    21118
    21119
  ];
  UDPPorts = [ 21116 ];
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "rustdesk-server"
      "relayIP"
    ] "This option has been replaced by services.rustdesk-server.signal.relayHosts")
    (lib.mkRenamedOptionModule
      [ "services" "rustdesk-server" "extraRelayArgs" ]
      [ "services" "rustdesk-server" "relay" "extraArgs" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "rustdesk-server" "extraSignalArgs" ]
      [ "services" "rustdesk-server" "signal" "extraArgs" ]
    )
  ];

  options.services.rustdesk-server =
    with lib;
    with types;
    {
      enable = mkEnableOption "RustDesk, a remote access and remote control software, allowing maintenance of computers and other devices";

      package = mkPackageOption pkgs "rustdesk-server" { };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open the connection ports.
          TCP (${lib.concatStringsSep ", " (map toString TCPPorts)})
          UDP (${lib.concatStringsSep ", " (map toString UDPPorts)})
        '';
      };

      signal = {
        enable = mkOption {
          type = bool;
          default = true;
          description = ''
            Whether to enable the RustDesk signal server.
          '';
        };

        relayHosts = mkOption {
          type = listOf str;
          default = [ ];
          # reference: https://rustdesk.com/docs/en/self-host/rustdesk-server-pro/relay/
          description = ''
            The relay server IP addresses or DNS names of the RustDesk relay.
          '';
        };

        extraArgs = mkOption {
          type = listOf str;
          default = [ ];
          example = [
            "-k"
            "_"
          ];
          description = ''
            A list of extra command line arguments to pass to the `hbbs` process.
          '';
        };

      };

      relay = {
        enable = mkOption {
          type = bool;
          default = true;
          description = ''
            Whether to enable the RustDesk relay server.
          '';
        };
        extraArgs = mkOption {
          type = listOf str;
          default = [ ];
          example = [
            "-k"
            "_"
          ];
          description = ''
            A list of extra command line arguments to pass to the `hbbr` process.
          '';
        };
      };

    };

  config =
    let
      cfg = config.services.rustdesk-server;
      serviceDefaults = {
        enable = true;
        requiredBy = [ "rustdesk.target" ];
        serviceConfig = {
          Slice = "system-rustdesk.slice";
          User = "rustdesk";
          Group = "rustdesk";
          DynamicUser = "yes";
          Environment = [ ];
          WorkingDirectory = "/var/lib/rustdesk";
          StateDirectory = "rustdesk";
          StateDirectoryMode = "0750";
          LockPersonality = true;
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RestrictNamespaces = true;
        };
      };
    in
    lib.mkIf cfg.enable {
      users.users.rustdesk = {
        description = "System user for RustDesk";
        isSystemUser = true;
        group = "rustdesk";
      };
      users.groups.rustdesk = { };

      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall TCPPorts;
      networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall UDPPorts;

      systemd.slices.system-rustdesk = {
        enable = true;
        description = "RustDesk Remote Desktop Slice";
      };

      systemd.targets.rustdesk = {
        enable = true;
        description = "Target designed to group RustDesk Signal & RustDesk Relay";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
      };

      systemd.services.rustdesk-signal =
        let
          relayArg = builtins.concatStringsSep ":" cfg.signal.relayHosts;
        in
        lib.mkIf cfg.signal.enable (
          lib.mkMerge [
            serviceDefaults
            {
              serviceConfig.ExecStart = "${cfg.package}/bin/hbbs --relay-servers ${relayArg} ${lib.escapeShellArgs cfg.signal.extraArgs}";
            }
          ]
        );

      systemd.services.rustdesk-relay = lib.mkIf cfg.relay.enable (
        lib.mkMerge [
          serviceDefaults
          {
            serviceConfig.ExecStart = "${cfg.package}/bin/hbbr ${lib.escapeShellArgs cfg.relay.extraArgs}";
          }
        ]
      );
    };

  meta.maintainers = with lib.maintainers; [ ppom ];
}
