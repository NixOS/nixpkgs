{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.arpwatch;

  interfaces = filterAttrs (_: v: v.enable) cfg.interfaces;
  defaultUser = "arpwatch";
  defaultGroup = "arpwatch";
  capabilities = [ "CAP_NET_RAW" ];

  interfaceOptions = { config, name, ... }: {
    options = {
      enable = mkOption {
        type = types.bool;
        description = lib.mdDoc "Whether to enable arpwatch instance.";
        default = cfg.enable;
      };

      package = mkOption {
        type = types.package;
        description = lib.mdDoc "arpwatch package.";
        default = cfg.package;
      };

      interface = mkOption {
        type = types.str;
        description = lib.mdDoc "Name of the interface to watch.";
        default = name;
      };

      datafile = mkOption {
        type = types.path;
        description = lib.mdDoc "Path to the datafile.";
        default = cfg.stateDir + "/arpwatch.${config.interface}.dat";
      };

      targetEmail = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc "Target address to send the email reports.";
        default = cfg.targetEmail;
      };

      fromEmail = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc "From address to send the email reports.";
        default = cfg.fromEmail;
      };

      flags = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc "Arguments to use for executing arpwatch.";
        default = [
          "-i '${config.interface}'"
          "-f '${config.datafile}'"
          (optionalString (config.targetEmail != null) "-w '${config.targetEmail}'")
          (optionalString (config.fromEmail != null) "-W '${config.fromEmail}'")
        ] ++ config.extraFlags;
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc "Extra arguments to use for executing arpwatch.";
        default = cfg.extraFlags;
      };
    };
  };

in
{
  options.services.arpwatch = {
    enable = mkEnableOption (lib.mdDoc "Arpwatch, keep track of ethernet/ip address pairings");

    package = mkPackageOption pkgs "arpwatch" { };

    interfaces = mkOption {
      type = types.attrsOf (types.submodule interfaceOptions);
      description = lib.mdDoc "Set of interfaces to monitor.";
      default = { };
    };

    user = mkOption {
      type = types.str;
      description = lib.mdDoc "The user to run arpwatch as.";
      default = "arpwatch";
    };

    group = mkOption {
      type = types.str;
      description = lib.mdDoc "The group to run arpwatch under.";
      default = "arpwatch";
    };

    stateDir = mkOption {
      type = types.path;
      description = lib.mdDoc "The path to the arpwatch state directory.";
      default = "/var/lib/arpwatch";
    };

    targetEmail = mkOption {
      type = types.nullOr types.str;
      description = lib.mdDoc "Target address to send the email reports.";
      default = null;
    };

    fromEmail = mkOption {
      type = types.nullOr types.str;
      description = lib.mdDoc "From address to send the email reports.";
      default = "arpwatch@${config.networking.fqdn}";
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      description = lib.mdDoc "Global extra arguments to use for executing arpwatch.";
      default = [ "-N" "-p" ];
    };
  };

  config = mkIf cfg.enable {
    systemd.services = mapAttrs'
      (n: v: {
        name = "arpwatch-${v.interface}";
        value = {
          description = "Watch ARP on interface ${v.interface}";
          after = [ "network.target" ];
          serviceConfig = {
            Type = "forking";
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = cfg.stateDir;
            ExecStartPre = "${pkgs.coreutils}/bin/touch ${v.datafile}";
            ExecStart = "${pkgs.arpwatch}/bin/arpwatch " + (concatStringsSep " " v.flags);
            Restart = "on-failure";
            RestartSec = 15;
            AmbientCapabilities = capabilities;
            CapabilityBoundingSet = capabilities;
          };
        };
      })
      interfaces;

    systemd.tmpfiles.rules = [ "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -" ];

    users.users = mkIf (cfg.user == defaultUser) {
      arpwatch = {
        home = "${cfg.stateDir}";
        isSystemUser = true;
        group = cfg.group;
      };
    };
    users.groups = mkIf (cfg.group == defaultGroup) {
      arpwatch = { };
    };
  };

  meta.maintainers = with lib.maintainers; [ nalves599 ];
}


