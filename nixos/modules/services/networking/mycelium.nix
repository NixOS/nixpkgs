{ config, pkgs, lib, ... }:

let
  cfg = config.services.mycelium;
in
{
  options.services.mycelium = {
    enable = lib.mkEnableOption "mycelium network";
    peers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        List of peers to connect to, in the formats:
         - `quic://[2001:0db8::1]:9651`
         - `quic://192.0.2.1:9651`
         - `tcp://[2001:0db8::1]:9651`
         - `tcp://192.0.2.1:9651`

        If addHostedPublicNodes is set to true, the hosted public nodes will also be added.
      '';
      default = [ ];
    };
    keyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Optional path to a file containing the mycelium key material.
        If unset, the default location (`/var/lib/mycelium/key.bin`) will be used.
        If no key exist at this location, it will be generated on startup.
      '';
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the firewall for mycelium";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.mycelium;
      defaultText = lib.literalExpression ''"''${pkgs.mycelium}"'';
      description = "The mycelium package to use";
    };
    addHostedPublicNodes = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Adds the hosted peers from https://github.com/threefoldtech/mycelium#hosted-public-nodes.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ 9651 ];
    networking.firewall.allowedUDPPorts = lib.optionals cfg.openFirewall [ 9650 9651 ];

    systemd.services.mycelium = {
      description = "Mycelium network";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [
        cfg.keyFile
      ];

      unitConfig.Documentation = "https://github.com/threefoldtech/mycelium";

      serviceConfig = {
        User = "mycelium";
        DynamicUser = true;
        StateDirectory = "mycelium";
        ProtectHome = true;
        ProtectSystem = true;
        LoadCredential = lib.mkIf (cfg.keyFile != null) "keyfile:${cfg.keyFile}";
        SyslogIdentifier = "mycelium";
        AmbientCapabilities = [ "CAP_NET_ADMIN" ];
        MemoryDenyWriteExecute = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged @keyring" ];
        ExecStart = lib.concatStringsSep " " ([
          (lib.getExe cfg.package)
          (if (cfg.keyFile != null) then
            "--key-file \${CREDENTIALS_DIRECTORY}/keyfile" else
            "--key-file %S/mycelium/key.bin"
          )
          "--tun-name"
          "mycelium"
        ] ++
        (lib.optional (cfg.addHostedPublicNodes || cfg.peers != [ ]) "--peers")
        ++ cfg.peers ++ (lib.optionals cfg.addHostedPublicNodes [
          "tcp://188.40.132.242:9651" # DE 01
          "tcp://[2a01:4f8:221:1e0b::2]:9651"
          "quic://188.40.132.242:9651"
          "quic://[2a01:4f8:221:1e0b::2]:9651"

          "tcp://136.243.47.186:9651" # DE 02
          "tcp://[2a01:4f8:212:fa6::2]:9651"
          "quic://136.243.47.186:9651"
          "quic://[2a01:4f8:212:fa6::2]:9651"

          "tcp://185.69.166.7:9651" # BE 03
          "tcp://[2a02:1802:5e:0:8478:51ff:fee2:3331]:9651"
          "quic://185.69.166.7:9651"
          "quic://[2a02:1802:5e:0:8478:51ff:fee2:3331]:9651"

          "tcp://185.69.166.8:9651" # BE 04
          "tcp://[2a02:1802:5e:0:8c9e:7dff:fec9:f0d2]:9651"
          "quic://185.69.166.8:9651"
          "quic://[2a02:1802:5e:0:8c9e:7dff:fec9:f0d2]:9651"

          "tcp://65.21.231.58:9651" # FI 05
          "tcp://[2a01:4f9:6a:1dc5::2]:9651"
          "quic://65.21.231.58:9651"
          "quic://[2a01:4f9:6a:1dc5::2]:9651"

          "tcp://65.109.18.113:9651" # FI 06
          "tcp://[2a01:4f9:5a:1042::2]:9651"
          "quic://65.109.18.113:9651"
          "quic://[2a01:4f9:5a:1042::2]:9651"
        ]));
        Restart = "always";
        RestartSec = 5;
        TimeoutStopSec = 5;
      };
    };
  };
  meta = {
    maintainers = with lib.maintainers; [ flokli lassulus ];
  };
}

