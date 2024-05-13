{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.jotta-cli;
in {
  options = {
    services.jotta-cli = {

      enable = mkEnableOption "Jottacloud Command-line Tool";

      options = mkOption {
        default = [ "stdoutlog" "datadir" "%h/.jottad/" ];
        example = [ ];
        type = with types; listOf str;
        description = "Command-line options passed to jottad.";
      };

      package = lib.mkPackageOption pkgs "jotta-cli" { };
    };
  };
  config = mkIf cfg.enable {
    systemd.user.services.jottad = {

      description = "Jottacloud Command-line Tool daemon";

      serviceConfig = {
        Type = "notify";
        EnvironmentFile = "-%h/.config/jotta-cli/jotta-cli.env";
        ExecStart = "${lib.getExe' cfg.package "jottad"} ${concatStringsSep " " cfg.options}";
        Restart = "on-failure";
      };

      wantedBy = [ "default.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };
    environment.systemPackages = [ pkgs.jotta-cli ];
  };

  meta.maintainers = with lib.maintainers; [ evenbrenden ];
  meta.doc = ./jotta-cli.md;
}
