{ config, lib, pkgs, ...}:

with lib;

let

  cfg = config.services.clarissa;

in {

  options.services.clarissa = {

    enable = mkEnableOption "the network census daemon.";

    quiet = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to nag an entity hasn't been heard from for a timeout period.";
    };

    promiscuous = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to set the used interface to promiscuous mode.";
    };

    interface = mkOption {
      type = types.str;
      default = "";
      example = "eth0";
      description = "Network interface to use instead of the automatically selected one.";
    };

    interval = mkOption {
      type = types.ints.unsigned;
      default = 1250;
      description = "How often to nag and cull the list of known entities (in ms).";
    };

    nags = mkOption {
      type = types.ints.unsigned;
      default = 4;
      description = "How many times to send a frame to a timed out entity.";
    };

    timeout = mkOption {
      type = types.ints.unsigned;
      default = 5000;
      description = "Time in ms to wait before nagging or culling an entry.";
    };

    subnet = mkOption {
      type = types.str;
      default = "";
      example = "192.168.0.0/16";
      description = "Subnet to filter frames by (in CIDR notation).";
    };

    outputFile = mkOption {
      type = types.str;
      default = "";
      example = "/tmp/clar_[dev]_[subnet]-[mask]";
      description = "Overwrite the default generated filename";
    };

    outputInterval = mkOption {
      type = types.ints.unsigned;
      default = 2500;
      description = "How often to update the outputFile.";
    };

    extraOptions = mkOption {
      type = types.str;
      default = "";
      example = "-vvv";
      description = "Additional options passed to the command.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.clarissa = {
      description = "the network census daemon";
      documentation = [ "https://gitlab.com/evils/clarissa" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      postStop = "rm -f /tmp/clar_*";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 1;
        StartLimitBurst = 10;
        ExecStart = "${pkgs.clarissa}/bin/clarissa "
          + (optionalString cfg.quiet "--quiet ")
          + (optionalString cfg.promiscuous "--promiscuous ")
          + "--interval ${toString cfg.interval} "
          + "--nags ${toString cfg.nags} "
          + "--timeout ${toString cfg.timeout} "
          + "--output_interval ${toString cfg.outputInterval} "
          + (optionalString (cfg.subnet != "") "--subnet ${cfg.subnet} ")
          + (optionalString (cfg.outputFile != "") "--output_file ${cfg.outputFile} ")
          + (optionalString (cfg.interface != "") "--interface ${cfg.interface} ")
          + "${cfg.extraOptions} ";
      };
    };
  };
}
