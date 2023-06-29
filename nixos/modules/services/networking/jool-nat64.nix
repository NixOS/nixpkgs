{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.jool-nat64;
  settingsFormat = pkgs.formats.json { };
in {
  options.services.jool-nat64 = {
    enable = mkEnableOption (lib.mdDoc "NAT64 translation using jool");

    instances = mkOption {
      type = types.attrsOf (types.submodule {
        freeformType = settingsFormat.type;
        options = {
          # explicitly list this option to have the default value
          framework = mkOption {
            type = types.enum [ "iptables" "netfilter" ];
            description = "the framework used to configure the instance";
            default = "netfilter";
          };
        };
      });
      default = {
        default = {
          framework = "netfilter";
          global.pool6 = "64:ff9b::/96";
        };
      };
      description = lib.mdDoc ''
        Attribute set of jool instance configurations. The attribute names are the instance names.
        See <https://nicmx.github.io/Jool/en/config-atomic.html#nat64> for possible configuration options.
      '';
      example = literalExpression ''
        {
          example = {
            global = {
              pool6 = "64:ff9b::/96";
              pool4 = "192.0.2.1/32";
              icmp-timeout = "0:01:00";
            };
          };
          secondary = {
            global.pool6 = "2001:db8:6464::/96";
            denylist =  [ "192.168.0.0/16" ];
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {

    boot.extraModulePackages = with config.boot.kernelPackages; [ jool ];

    systemd.services = lib.mapAttrs' (name: value:
      let
        configFile = pkgs.writeText "config"
          # ensure that the instance name is set and matches the attribute name
          (builtins.toJSON (value // { instance = name; }));
      in lib.nameValuePair "jool-nat64-${name}" {
        description = "jool stateful NAT64";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStartPre = "${pkgs.kmod}/bin/modprobe jool";
          ExecStart = "${pkgs.jool-cli}/bin/jool file handle ${configFile}";
          ExecStop = "${pkgs.jool-cli}/bin/jool instance remove ${name}";
          Type = "oneshot";
          RemainAfterExit = true;

          DynamicUser = true;
          AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_SYS_MODULE" ];
          CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_SYS_MODULE" ];
          RestrictAddressFamilies = [ "AF_NETLINK" ];
          ProtectSystem = true;
          ProtectHome = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = [ "native" ];
          UMask = "0077";
        };
      }) cfg.instances;
  };
}
