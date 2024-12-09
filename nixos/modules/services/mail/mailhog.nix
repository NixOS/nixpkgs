{ config, lib, pkgs, ... }:
let
  cfg = config.services.mailhog;

  args = lib.concatStringsSep " " (
    [
      "-api-bind-addr :${toString cfg.apiPort}"
      "-smtp-bind-addr :${toString cfg.smtpPort}"
      "-ui-bind-addr :${toString cfg.uiPort}"
      "-storage ${cfg.storage}"
    ] ++ lib.optional (cfg.storage == "maildir")
      "-maildir-path $STATE_DIRECTORY"
    ++ cfg.extraArgs
  );

in
{
  ###### interface

  imports = [
    (lib.mkRemovedOptionModule [ "services" "mailhog" "user" ] "")
  ];

  options = {

    services.mailhog = {
      enable = lib.mkEnableOption "MailHog, web and API based SMTP testing";

      storage = lib.mkOption {
        type = lib.types.enum [ "maildir" "memory" ];
        default = "memory";
        description = "Store mails on disk or in memory.";
      };

      apiPort = lib.mkOption {
        type = lib.types.port;
        default = 8025;
        description = "Port on which the API endpoint will listen.";
      };

      smtpPort = lib.mkOption {
        type = lib.types.port;
        default = 1025;
        description = "Port on which the SMTP endpoint will listen.";
      };

      uiPort = lib.mkOption {
        type = lib.types.port;
        default = 8025;
        description = "Port on which the HTTP UI will listen.";
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of additional arguments to pass to the MailHog process.";
      };
    };
  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    systemd.services.mailhog = {
      description = "MailHog - Web and API based SMTP testing";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.mailhog}/bin/MailHog ${args}";
        DynamicUser = true;
        Restart = "on-failure";
        StateDirectory = "mailhog";
      };
    };
  };
}
