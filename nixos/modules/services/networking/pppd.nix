{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pppd;
in
{
  meta = {
    maintainers = with maintainers; [ danderson ];
  };

  options = {
    services.pppd = {
      enable = mkEnableOption "pppd";

      package = mkOption {
        default = pkgs.ppp;
        defaultText = "pkgs.ppp";
        type = types.package;
        description = "pppd package to use.";
      };

      peers = mkOption {
        default = {};
        description = "pppd peers.";
        type = types.attrsOf (types.submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
                example = "dialup";
                description = "Name of the PPP peer.";
              };

              enable = mkOption {
                type = types.bool;
                default = true;
                example = false;
                description = "Whether to enable this PPP peer.";
              };

              autostart = mkOption {
                type = types.bool;
                default = true;
                example = false;
                description = "Whether the PPP session is automatically started at boot time.";
              };

              config = mkOption {
                type = types.lines;
                default = "";
                description = "pppd configuration for this peer, see the pppd(8) man page.";
              };
            };
          }));
      };
    };
  };

  config = let
    enabledConfigs = filter (f: f.enable) (attrValues cfg.peers);

    mkEtc = peerCfg: {
      name = "ppp/peers/${peerCfg.name}";
      value.text = peerCfg.config;
    };

    mkSystemd = peerCfg: {
      name = "pppd-${peerCfg.name}";
      value = {
        restartTriggers = [ config.environment.etc."ppp/peers/${peerCfg.name}".source ];
        before = [ "network.target" ];
        wants = [ "network.target" ];
        after = [ "network-pre.target" ];
        environment = {
          # pppd likes to write directly into /var/run. This is rude
          # on a modern system, so we use libredirect to transparently
          # move those files into /run/pppd.
          LD_PRELOAD = "${pkgs.libredirect}/lib/libredirect.so";
          NIX_REDIRECTS = "/var/run=/run/pppd";
        };
        serviceConfig = {
          ExecStart = "${getBin cfg.package}/sbin/pppd call ${peerCfg.name} nodetach nolog";
          Restart = "always";
          RestartSec = 5;

          AmbientCapabilities = "CAP_SYS_TTY_CONFIG CAP_NET_ADMIN CAP_NET_RAW CAP_SYS_ADMIN";
          CapabilityBoundingSet = "CAP_SYS_TTY_CONFIG CAP_NET_ADMIN CAP_NET_RAW CAP_SYS_ADMIN";
          KeyringMode = "private";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateMounts = true;
          PrivateTmp = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelModules = true;
          # pppd can be configured to tweak kernel settings.
          ProtectKernelTunables = false;
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictAddressFamilies = "AF_PACKET AF_UNIX AF_PPPOX AF_ATMPVC AF_ATMSVC AF_INET AF_INET6 AF_IPX";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SecureBits = "no-setuid-fixup-locked noroot-locked";
          SystemCallFilter = "@system-service";
          SystemCallArchitectures = "native";

          # All pppd instances on a system must share a runtime
          # directory in order for PPP multilink to work correctly. So
          # we give all instances the same /run/pppd directory to store
          # things in.
          #
          # For the same reason, we can't set PrivateUsers=true, because
          # all instances need to run as the same user to access the
          # multilink database.
          RuntimeDirectory = "pppd";
          RuntimeDirectoryPreserve = true;
        };
        wantedBy = mkIf peerCfg.autostart [ "multi-user.target" ];
      };
    };

    etcFiles = listToAttrs (map mkEtc enabledConfigs);
    systemdConfigs = listToAttrs (map mkSystemd enabledConfigs);

  in mkIf cfg.enable {
    environment.etc = mkMerge etcFiles;
    systemd.services = mkMerge systemdConfigs;
  };
}
