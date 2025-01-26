{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.jotta-cli;
in
{
  options = {
    services.jotta-cli = {

      enable = lib.mkEnableOption "Jottacloud Command-line Tool";

      options = lib.mkOption {
        default = [
          "stdoutlog"
          "datadir"
          "%h/.jottad/"
        ];
        example = [ ];
        type = with lib.types; listOf str;
        description = "Command-line options passed to jottad.";
      };

      package = lib.mkPackageOption pkgs "jotta-cli" { };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.jottad = {

      description = "Jottacloud Command-line Tool daemon";

      serviceConfig = {
        Type = "notify";
        EnvironmentFile = "-%h/.config/jotta-cli/jotta-cli.env";
        ExecStart = "${lib.getExe' cfg.package "jottad"} ${lib.concatStringsSep " " cfg.options}";
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
