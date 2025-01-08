{ config, lib, pkgs, ... }:

let
  paramLib = (import ./param-lib.nix lib);
in

let
  cfg = config.services.strongswan-swanctl;
  configFile = pkgs.writeText "swanctl.conf"
      ( (paramLib.paramsToConf cfg.swanctl swanctlParams)
      + (lib.concatMapStrings (i: "\ninclude ${i}") cfg.includes));
  swanctlParams = import ./swanctl-params.nix lib;
in  {
  options.services.strongswan-swanctl = {
    enable = lib.mkEnableOption "strongswan-swanctl service";

    package = lib.mkPackageOption pkgs "strongswan" { };

    strongswan.extraConfig = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Contents of the `strongswan.conf` file.
      '';
    };

    swanctl = paramLib.paramsToOptions swanctlParams;
    includes = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
      description = ''
        Extra configuration files to include in the swanctl configuration. This can be used to provide secret values from outside the nix store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      { assertion = !config.services.strongswan.enable;
        message = "cannot enable both services.strongswan and services.strongswan-swanctl. Choose either one.";
      }
    ];

    environment.etc."swanctl/swanctl.conf".source = configFile;

    # The swanctl command complains when the following directories don't exist:
    # See: https://wiki.strongswan.org/projects/strongswan/wiki/Swanctldirectory
    systemd.tmpfiles.rules = [
      "d /etc/swanctl/x509 -"     # Trusted X.509 end entity certificates
      "d /etc/swanctl/x509ca -"   # Trusted X.509 Certificate Authority certificates
      "d /etc/swanctl/x509ocsp -"
      "d /etc/swanctl/x509aa -"   # Trusted X.509 Attribute Authority certificates
      "d /etc/swanctl/x509ac -"   # Attribute Certificates
      "d /etc/swanctl/x509crl -"  # Certificate Revocation Lists
      "d /etc/swanctl/pubkey -"   # Raw public keys
      "d /etc/swanctl/private -"  # Private keys in any format
      "d /etc/swanctl/rsa -"      # PKCS#1 encoded RSA private keys
      "d /etc/swanctl/ecdsa -"    # Plain ECDSA private keys
      "d /etc/swanctl/bliss -"
      "d /etc/swanctl/pkcs8 -"    # PKCS#8 encoded private keys of any type
      "d /etc/swanctl/pkcs12 -"   # PKCS#12 containers
    ];

    systemd.services.strongswan-swanctl = {
      description = "strongSwan IPsec IKEv1/IKEv2 daemon using swanctl";
      wantedBy = [ "multi-user.target" ];
      wants    = [ "network-online.target" ];
      after    = [ "network-online.target" ];
      path     = with pkgs; [ kmod iproute2 iptables util-linux ];
      environment = {
        STRONGSWAN_CONF = pkgs.writeTextFile {
          name = "strongswan.conf";
          text = cfg.strongswan.extraConfig;
        };
        SWANCTL_DIR = "/etc/swanctl";
      };
      restartTriggers = [ config.environment.etc."swanctl/swanctl.conf".source ];
      serviceConfig = {
        ExecStart     = "${cfg.package}/sbin/charon-systemd";
        Type          = "notify";
        ExecStartPost = "${cfg.package}/sbin/swanctl --load-all --noprompt";
        ExecReload    = "${cfg.package}/sbin/swanctl --reload";
        Restart       = "on-abnormal";
      };
    };
  };
}
