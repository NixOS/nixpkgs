{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.arbtt;
in
{
  options = {
    services.arbtt = {
      enable = mkEnableOption "Arbtt statistics capture service";

      package = mkPackageOption pkgs [
        "haskellPackages"
        "arbtt"
      ] { };

      logFile = mkOption {
        type = types.str;
        default = "%h/.arbtt/capture.log";
        example = "/home/username/.arbtt-capture.log";
        description = ''
          The log file for captured samples.
        '';
      };

      sampleRate = mkOption {
        type = types.int;
        default = 60;
        example = 120;
        description = ''
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

  meta.maintainers = [ ];
}
