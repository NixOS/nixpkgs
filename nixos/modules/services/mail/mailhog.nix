{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.mailhog;

  args = lib.concatStringsSep " " (
    [
      "-api-bind-addr :${toString cfg.apiPort}"
      "-smtp-bind-addr :${toString cfg.smtpPort}"
      "-ui-bind-addr :${toString cfg.uiPort}"
      "-storage ${cfg.storage}"
    ]
    ++ lib.optional (cfg.storage == "maildir") "-maildir-path $STATE_DIRECTORY"
    ++ cfg.extraArgs
  );

in
{
  ###### interface

  imports = [
    (mkRemovedOptionModule [
      "services"
      "mailhog"
      "user"
    ] "")
  ];

  options = {

    services.mailhog = {
      enable = mkEnableOption "MailHog, web and API based SMTP testing";

      storage = mkOption {
        type = types.enum [
          "maildir"
          "memory"
        ];
        default = "memory";
        description = "Store mails on disk or in memory.";
      };

      apiPort = mkOption {
        type = types.port;
        default = 8025;
        description = "Port on which the API endpoint will listen.";
      };

      smtpPort = mkOption {
        type = types.port;
        default = 1025;
        description = "Port on which the SMTP endpoint will listen.";
      };

      uiPort = mkOption {
        type = types.port;
        default = 8025;
        description = "Port on which the HTTP UI will listen.";
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of additional arguments to pass to the MailHog process.";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

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
