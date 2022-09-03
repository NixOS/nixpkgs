{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.arbtt;
in {
  options = {
    services.arbtt = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable the arbtt statistics capture service.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.haskellPackages.arbtt;
        defaultText = literalExpression "pkgs.haskellPackages.arbtt";
        description = lib.mdDoc ''
          The package to use for the arbtt binaries.
        '';
      };

      logFile = mkOption {
        type = types.str;
        default = "%h/.arbtt/capture.log";
        example = "/home/username/.arbtt-capture.log";
        description = lib.mdDoc ''
          The log file for captured samples.
        '';
      };

      sampleRate = mkOption {
        type = types.int;
        default = 60;
        example = 120;
        description = lib.mdDoc ''
          The sampling interval in seconds.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.arbtt = {
      description = "arbtt statistics capture service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/arbtt-capture --logfile=${cfg.logFile} --sample-rate=${toString cfg.sampleRate}";
        Restart = "always";
      };
    };
  };

  meta.maintainers = [ maintainers.michaelpj ];
}
