{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.mailcatcher;

  inherit (lib)
    mkEnableOption
    mkIf
    lib.mkOption
    types
    lib.optionalString
    ;
in
{
  # interface

  options = {

    services.mailcatcher = {
      enable = lib.mkEnableOption "MailCatcher, an SMTP server and web interface to locally test outbound emails";

      http.ip = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The ip address of the http server.";
      };

      http.port = lib.mkOption {
        type = lib.types.port;
        default = 1080;
        description = "The port address of the http server.";
      };

      http.path = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Prefix to all HTTP paths.";
        example = "/mailcatcher";
      };

      smtp.ip = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The ip address of the smtp server.";
      };

      smtp.port = lib.mkOption {
        type = lib.types.port;
        default = 1025;
        description = "The port address of the smtp server.";
      };
    };

  };

  # implementation

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mailcatcher ];

    systemd.services.mailcatcher = {
      description = "MailCatcher Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        ExecStart =
          "${pkgs.mailcatcher}/bin/mailcatcher --foreground --no-quit --http-ip ${cfg.http.ip} --http-port ${toString cfg.http.port} --smtp-ip ${cfg.smtp.ip} --smtp-port ${toString cfg.smtp.port}"
          + lib.optionalString (cfg.http.path != null) " --http-path ${cfg.http.path}";
        AmbientCapabilities = lib.optionalString (
          cfg.http.port < 1024 || cfg.smtp.port < 1024
        ) "cap_net_bind_service";
      };
    };
  };
}
