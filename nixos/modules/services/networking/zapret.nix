{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.zapret;
in
{
  options.services.zapret = {
    enable = mkEnableOption "DPI bypass multi platform service";

    package = mkPackageOption pkgs "zapret" { };

    settings = mkOption {
      type = types.lines;
      default = "";

      example = ''
        TPWS_OPT="--hostspell=HOST --split-http-req=method --split-pos=3 --oob"
        NFQWS_OPT_DESYNC="--dpi-desync-ttl=5"
      '';

      description = ''
        Rules for zapret to work. Run ```nix-shell -p zapret --command blockcheck``` to get values to pass here.

        Config example can be found here https://github.com/bol-van/zapret/blob/master/config.default
      '';
    };

    firewallType = mkOption {
      type = types.enum [
        "iptables"
        "nftables"
      ];
      default = "iptables";
      description = ''
        Which firewall zapret should use
      '';
    };

    disableIpv6 = mkOption {
      type = types.bool;
      # recommended by upstream
      default = true;
      description = ''
        Disable or enable usage of IpV6 by zapret
      '';
    };

    mode = mkOption {
      type = types.enum [
        "tpws"
        "tpws-socks"
        "nfqws"
        "filter"
        "custom"
      ];
      default = "tpws";
      description = ''
        Which mode zapret should use
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.tpws = {
      isSystemUser = true;
      group = "tpws";
    };

    users.groups.tpws = { };

    systemd.services.zapret = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        (if cfg.firewallType == "iptables" then iptables else nftables)
        gawk
        ipset
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

        EnvironmentFile = pkgs.writeText "${cfg.package.pname}-environment" (concatStrings [
          ''
            MODE=${cfg.mode}
            FWTYPE=${cfg.firewallType}
            DISABLE_IPV6=${if cfg.disableIpv6 then "1" else "0"}

          ''
          cfg.settings
        ]);

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
