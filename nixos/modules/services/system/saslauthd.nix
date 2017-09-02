{ config, lib, pkgs, ... }:

with lib;

let

  nssModulesPath = config.system.nssModules.path;
  cfg = config.services.saslauthd;

in

{

  ###### interface

  options = {

    services.saslauthd = {

      enable = mkEnableOption "Whether to enable the Cyrus SASL authentication daemon.";

      package = mkOption {
        default = pkgs.cyrus_sasl.bin;
        defaultText = "pkgs.cyrus_sasl.bin";
        type = types.package;
        description = "Cyrus SASL package to use.";
      };

      mechanism = mkOption {
        type = types.str;
        default = "pam";
        description = "Auth mechanism to use";
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = "Configuration to use for Cyrus SASL authentication daemon.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

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
