{ config, lib, pkgs, ... }:

with lib;
with (import ./param-lib.nix lib);

let
  cfg = config.services.strongswan-swanctl;
  swanctlParams = import ./swanctl-params.nix lib;
in  {
  options.services.strongswan-swanctl = {
    enable = mkEnableOption (lib.mdDoc "strongswan-swanctl service");

    package = mkOption {
      type = types.package;
      default = pkgs.strongswan;
      defaultText = literalExpression "pkgs.strongswan";
      description = lib.mdDoc ''
        The strongswan derivation to use.
      '';
    };

    strongswan.extraConfig = mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc ''
        Contents of the `strongswan.conf` file.
      '';
    };

    swanctl = paramsToOptions swanctlParams;
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = !config.services.strongswan.enable;
        message = "cannot enable both services.strongswan and services.strongswan-swanctl. Choose either one.";
      }
    ];

    environment.etc."swanctl/swanctl.conf".text =
      paramsToConf cfg.swanctl swanctlParams;

    # The swanctl command complains when the following directories don't exist:
    # See: https://wiki.strongswan.org/projects/strongswan/wiki/Swanctldirectory
    system.activationScripts.strongswan-swanctl-etc = stringAfter ["etc"] ''
      mkdir -p '/etc/swanctl/x509'     # Trusted X.509 end entity certificates
      mkdir -p '/etc/swanctl/x509ca'   # Trusted X.509 Certificate Authority certificates
      mkdir -p '/etc/swanctl/x509ocsp'
      mkdir -p '/etc/swanctl/x509aa'   # Trusted X.509 Attribute Authority certificates
      mkdir -p '/etc/swanctl/x509ac'   # Attribute Certificates
      mkdir -p '/etc/swanctl/x509crl'  # Certificate Revocation Lists
      mkdir -p '/etc/swanctl/pubkey'   # Raw public keys
      mkdir -p '/etc/swanctl/private'  # Private keys in any format
      mkdir -p '/etc/swanctl/rsa'      # PKCS#1 encoded RSA private keys
      mkdir -p '/etc/swanctl/ecdsa'    # Plain ECDSA private keys
      mkdir -p '/etc/swanctl/bliss'
      mkdir -p '/etc/swanctl/pkcs8'    # PKCS#8 encoded private keys of any type
      mkdir -p '/etc/swanctl/pkcs12'   # PKCS#12 containers
    '';

    systemd.services.strongswan-swanctl = {
      description = "strongSwan IPsec IKEv1/IKEv2 daemon using swanctl";
      wantedBy = [ "multi-user.target" ];
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
