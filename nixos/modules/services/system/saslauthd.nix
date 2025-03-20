{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.saslauthd;

in

{

  ###### interface

  options = {

    services.saslauthd = {

      enable = lib.mkEnableOption "saslauthd, the Cyrus SASL authentication daemon";

      package = lib.mkPackageOption pkgs [ "cyrus_sasl" "bin" ] { };

      mechanism = lib.mkOption {
        type = lib.types.str;
        default = "pam";
        description = "Auth mechanism to use";
      };

      config = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Configuration to use for Cyrus SASL authentication daemon.";
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    systemd.services.saslauthd = {
      description = "Cyrus SASL authentication daemon";

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "@${cfg.package}/sbin/saslauthd saslauthd -a ${cfg.mechanism} -O ${pkgs.writeText "saslauthd.conf" cfg.config}";
        Type = "forking";
        PIDFile = "/run/saslauthd/saslauthd.pid";
        Restart = "always";
      };
    };
  };
}
