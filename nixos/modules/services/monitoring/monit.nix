{config, pkgs, lib, ...}:

with lib;

let
  cfg = config.services.monit;
  extraConfig = pkgs.writeText "monitConfig" cfg.extraConfig;
in

{
  imports = [
    (mkRenamedOptionModule [ "services" "monit" "config" ] ["services" "monit" "extraConfig" ])
  ];

  options.services.monit = {

    enable = mkEnableOption "Monit";

    configFiles = mkOption {
      type = types.listOf types.path;
      default = [];
      description = "List of paths to be included in the monitrc file";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional monit config as string";
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.monit ];

    environment.etc.monitrc = {
      text = concatMapStringsSep "\n" (path: "include ${path}")  (cfg.configFiles ++ [extraConfig]);
      mode = "0400";
    };

    systemd.services.monit = {
      description = "Pro-active monitoring utility for unix systems";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.monit}/bin/monit -I -c /etc/monitrc";
        ExecStop = "${pkgs.monit}/bin/monit -c /etc/monitrc quit";
        ExecReload = "${pkgs.monit}/bin/monit -c /etc/monitrc reload";
        KillMode = "process";
        Restart = "always";
      };
      restartTriggers = [ config.environment.etc.monitrc.source ];
    };

  };
}
