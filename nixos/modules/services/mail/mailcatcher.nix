{ config, pkgs, lib, ... }:

let
  cfg = config.services.mailcatcher;

  inherit (lib) mkEnableOption mkIf mkOption types;
in
{
  # interface

  options = {

    services.mailcatcher = {
      enable = mkEnableOption "MailCatcher";

      http.ip = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The ip address of the http server.";
      };

      http.port = mkOption {
        type = types.port;
        default = 1080;
        description = "The port address of the http server.";
      };

      smtp.ip = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The ip address of the smtp server.";
      };

      smtp.port = mkOption {
        type = types.port;
        default = 1025;
        description = "The port address of the smtp server.";
      };
    };

  };

  # implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mailcatcher ];

    systemd.services.mailcatcher = {
      description = "MailCatcher Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        ExecStart = "${pkgs.mailcatcher}/bin/mailcatcher --foreground --no-quit --http-ip ${cfg.http.ip} --http-port ${toString cfg.http.port} --smtp-ip ${cfg.smtp.ip} --smtp-port ${toString cfg.smtp.port}";
      };
    };
  };
}
