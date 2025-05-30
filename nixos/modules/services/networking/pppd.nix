{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.pppd;
in
{
  meta = {
    maintainers = [ ];
  };

  options = {
    services.pppd = {
      enable = mkEnableOption "pppd";

      package = mkPackageOption pkgs "ppp" { };

      peers = mkOption {
        default = { };
        description = "pppd peers.";
        type = types.attrsOf (
          types.submodule (
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
                  description = "pppd configuration for this peer, see the {manpage}`pppd(8)` man page.";
                };
              };
            }
          )
        );
      };
    };
  };

  config =
    let
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
          serviceConfig =
            let
              capabilities = [
                "CAP_BPF"
                "CAP_SYS_TTY_CONFIG"
                "CAP_NET_ADMIN"
                "CAP_NET_RAW"
              ];
            in
            {
              ExecStart = "${getBin cfg.package}/sbin/pppd call ${peerCfg.name} nodetach nolog";
              Restart = "always";
              RestartSec = 5;

              AmbientCapabilities = capabilities;
              CapabilityBoundingSet = capabilities;
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
              RestrictAddressFamilies = [
                "AF_ATMPVC"
                "AF_ATMSVC"
                "AF_INET"
                "AF_INET6"
                "AF_IPX"
                "AF_NETLINK"
                "AF_PACKET"
                "AF_PPPOX"
                "AF_UNIX"
              ];
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

    in
    mkIf cfg.enable {
      environment.etc = etcFiles;
      systemd.services = systemdConfigs;
    };
}
