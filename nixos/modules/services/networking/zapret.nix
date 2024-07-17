{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.zapret;
in {
  options.services.zapret = {
    enable = mkEnableOption "DPI bypass multi platform service";

    package = mkPackageOption pkgs "zapret" {};

    settings = mkOption {
      type = types.lines;
      default = "";

      example = ''
        MODE="nfqws"
        NFQWS_OPT_DESYNC="--dpi-desync-ttl=5"
      '';

      description = "
        Rules for zapret to work. Run ```bash nix-shell -p zapret --command blockcheck``` to get values to pass here.

        Config example can be found here https://github.com/bol-van/zapret/blob/${cfg.package.src.ref}/config
      ";
    };

    firewallType = mkOption {
      type = types.enum [ "iptables" "nftables" ];
      default = if config.networking.nftables.enable then "nftables" else "iptables";
      description = ''
        Which firewall zapret should use
      '';
    };

    disableIpv6 = mkOption {
      type = types.bool;
      # recommended by upstream
      default = true;
    };
  };


  config = mkIf cfg.enable {
    users.users.tpws = {
      isSystemUser = true;
      group = "tpws";
    };

    users.groups.tpws = {};

    systemd.services.zapret = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        (if cfg.firewallType == "iptables" then iptables else nftables)
        gawk
      ];

      serviceConfig = {
        Type = "forking";
        Restart = "no";
        TimeoutSec = "30sec";
        IgnoreSIGPIPE = "no";
        KillMode = "none";
        GuessMainPID = "no";
        RemainAfterExit = "no";
        ExecStart = "${cfg.package}/bin/zapret start";
        ExecStop = "${cfg.package}/bin/zapret stop";

        EnvironmentFile = pkgs.writeText "${cfg.package.pname}-environment" (concatStrings [ ''
          FWTYPE=${cfg.firewallType}
          DISABLE_IPV6=${if cfg.disableIpv6 then "1" else "0"}

        '' cfg.settings ]);

        # hardening
        DevicePolicy = "closed";
        KeyringMode = "private";
        PrivateTmp = true;
        PrivateMounts = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
      };
    };

    meta.maintainers = with maintainers; [ nishimara ];
  };
}
