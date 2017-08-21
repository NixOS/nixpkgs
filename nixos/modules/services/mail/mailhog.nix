{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mailhog;
in {
  ###### interface

  options = {

    services.mailhog = {
      enable = mkEnableOption "MailHog";
      user = mkOption {
        type = types.str;
        default = "mailhog";
        description = "User account under which mailhog runs.";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers.mailhog = {
      name = cfg.user;
      description = "MailHog service user";
    };

    systemd.services.mailhog = {
      description = "MailHog service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.mailhog}/bin/MailHog";
        User = cfg.user;
      };
    };
  };
}
