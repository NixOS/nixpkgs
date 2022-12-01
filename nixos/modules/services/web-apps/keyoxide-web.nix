{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.keyoxide-web;
in {
  options.services.keyoxide-web = {
    enable = mkEnableOption (mdDoc "A modern, secure and privacy-friendly platform to establish your decentralized online identity");

    port = mkOption {
      description = mdDoc "The port of the file server";
      type = types.port;
      default = 3000;
    };
    domain = mkOption {
      description = mdDoc "The domain on which the instance is hosted";
      example = "keyoxide.org";
      type = types.str;
      default = "";
    };
    onionUrl = mkOption {
      description = mdDoc "The onion URL that points to the same instance";
      example = "keyoxide3hd2j9djj.onion";
      type = types.str;
      default = "";
    };
    proxyHostname = mkOption {
      description = mdDoc "The hostname of the doip-proxy instance to use";
      type = types.str;
      default = "";
    };
    profileOne = {
      name = mkOption {
        description = mdDoc "The name of the first profile to hightlight on the main page";
        type = types.str;
        default = "";
      };
      description = mkOption {
        description = mdDoc "The subtitle of the first profile to hightlight on the main page";
        type = types.str;
        default = "";
      };
      fingerprint = mkOption {
        description = mdDoc "The fingerprint of the first profile to hightlight on the main page";
        type = types.str;
        default = "";
      };
    };
    profileTwo = {
      name = mkOption {
        description = mdDoc "The name of the second profile to hightlight on the main page";
        type = types.str;
        default = "";
      };
      description = mkOption {
        description = mdDoc "The subtitle of the second profile to hightlight on the main page";
        type = types.str;
        default = "";
      };
      fingerprint = mkOption {
        description = mdDoc "The fingerprint of the second profile to hightlight on the main page";
        type = types.str;
        default = "";
      };
    };
    profileThree = {
      name = mkOption {
        description = mdDoc "The name of the third profile to hightlight on the main page";
        type = types.str;
        default = "";
      };
      description = mkOption {
        description = mdDoc "The subtitle of the third profile to hightlight on the main page";
        type = types.str;
        default = "";
      };
      fingerprint = mkOption {
        description = mdDoc "The fingerprint of the third profile to hightlight on the main page";
        type = types.str;
        default = "";
      };
    };
    user = mkOption {
      type = types.str;
      default = "keyoxide-web";
      description = mdDoc "The user as which to run Keyoxide-web.";
    };
    group = mkOption {
      type = types.str;
      default = "keyoxide-web";
      description = mdDoc "The group as which to run Keyoxide-web.";
    };

  };

  config = mkIf cfg.enable {

    systemd.services.keyoxide-web = {
      description = mdDoc "Keyoxide Web service";
      documentation = [ "https://docs.keyoxide.org/" ];

      wantedBy = [ "multi-user.target" ];
      requires = [ "networking.target" ];

      environment = {
        PORT = toString cfg.port;
        DOMAIN = cfg.domain;
        ONION_URL = cfg.onionUrl;
        PROXY_HOSTNAME = cfg.proxyHostname;
        KX_HIGHLIGHTS_1_NAME = cfg.profileOne.name;
        KX_HIGHLIGHTS_1_DESCRIPTION = cfg.profileOne.description;
        KX_HIGHLIGHTS_1_FINGERPRINT = cfg.profileOne.fingerprint;
        KX_HIGHLIGHTS_2_NAME = cfg.profileTwo.name;
        KX_HIGHLIGHTS_2_DESCRIPTION = cfg.profileTwo.description;
        KX_HIGHLIGHTS_2_FINGERPRINT = cfg.profileTwo.fingerprint;
        KX_HIGHLIGHTS_3_NAME = cfg.profileThree.name;
        KX_HIGHLIGHTS_3_DESCRIPTION = cfg.profileThree.description;
        KX_HIGHLIGHTS_3_FINGERPRINT = cfg.profileThree.fingerprint;
      };

      serviceConfig = {
        Restart = "on-failure";
        User = cfg.user;
        SyslogIdentifier = "keyoxide-web";
        RestartSec = "10s";
        ExecStart = "${pkgs.keyoxide-web}/bin/keyoxide-web";
      };
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.${cfg.group} = {};

  };

  meta.maintainers = with maintainers; [ BrinkOfBailout ];
}
