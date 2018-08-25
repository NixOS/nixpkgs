{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.incron;

in

{
  options = {

    services.incron = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the incron daemon.";
      };

      allow = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "Users allowed to use incrontab.";
      };

      deny = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "Users forbidden from using incrontab.";
      };

      systab = mkOption {
        type = types.lines;
        default = "";
        description = "The system incrontab contents.";
        example = ''
          "/var/mail IN_CLOSE_WRITE abc $@/$#"
          "/tmp IN_ALL_EVENTS efg $@/$# $&"
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.incron ];

    security.wrappers.incrontab.source = "${pkgs.incron}/bin/incrontab";

    environment.etc."incron.d/system".text = "${cfg.systab}";
    environment.etc."incron.allow" = mkIf (cfg.allow != null) {
      text = "${concatStringsSep "\n" cfg.allow}";
    };
    environment.etc."incron.deny" = mkIf (cfg.deny != null) {
      text = "${concatStringsSep "\n" cfg.deny}";
    };

    systemd.services.incron = {
      description = "File system events scheduler";
      wantedBy = [ "multi-user.target" ];
      path = [ config.system.path ];
      preStart = "mkdir -m 710 -p /var/spool/incron";
      serviceConfig.Type = "forking";
      serviceConfig.PIDFile = "/run/incrond.pid";
      serviceConfig.ExecStart = "${pkgs.incron}/bin/incrond";
    };
  };

}
