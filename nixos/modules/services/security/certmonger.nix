{ pkgs, lib, config, ... }:
let
  cfg = config.services.certmonger;

  cfgFile = pkgs.writeText "certmonger.conf" cfg.config;
in
{
  options.services.certmonger = {
    enable = lib.mkEnableOption (lib.mdDoc "certmonger service");

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.certmonger;
      defaultText = lib.literalExpression "pkgs.certmonger";
      description = lib.mdDoc "certmonger package";
    };

    overrideHosts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = lib.mdDoc ''
        Remove /etc/hosts entries for "127.0.0.2" and "::1" defined in nixos/modules/config/networking.nix
        networking.fqdn must be able to resolve their hostnames to their IP addresses, through PTR records
        or /etc/hosts entries. Overwise IPA krb5 Keytab will try register as localhost.
      '';
    };

    config = lib.mkOption {
      type = lib.types.lines;
      description = lib.mdDoc ''
        Contents of {file}`certmonger.conf`.

        The certmonger.conf file contains default settings used by certmonger.
        Its format is more or less that of a typical INI-style file.
        The only sections currently of note are named defaults, selfsign and local.

        For more details see {manpage}`certmonger.conf(5)`.
      '';
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hosts = lib.mkIf cfg.overrideHosts {
      "127.0.0.2" = lib.mkForce [ ];
      "::1" = lib.mkForce [ ];
    };

    environment.systemPackages = [ cfg.package ];

    environment.etc."certmonger/certmonger.conf".source = cfgFile;

    systemd.services.certmonger = {
      after = [ "network.target" "dbus.service" ];
      partOf = [ "dbus.service" ];
      wantedBy = [ "multi-user.target" ];

      restartTriggers = [ cfgFile ];
      environment = {
        CERTMONGER_CONFIG_DIR = "/etc/certmonger";
      };

      serviceConfig = {
        Type = "dbus";
        StateDirectory = "certmonger";
        RuntimeDirectory = "certmonger";
        StateDirectoryMode = "0750";
        RuntimeDirectoryMode = "0750";
        PIDFile = "/run/certmonger/certmonger.pid";
        ExecStart = "${cfg.package}/bin/certmonger -S -p /run/certmonger/certmonger.pid -n";
        BusName = "org.fedorahosted.certmonger";
      };
    };
  };
}
