{ config, lib, pkgs, ... }:

with lib;
with (import ./param-lib.nix lib);

let
  cfg = config.services.strongswan-swanctl;

  # TODO: auto-generate these files using:
  # https://github.com/strongswan/strongswan/tree/master/conf
  # IDEA: extend the format-options.py script to output these Nix files.
  #strongswanParams = import ./strongswan-params.nix lib;
  swanctlParams    = import ./swanctl-params.nix    lib;
in  {
  options.services.strongswan-swanctl = {
    enable = mkEnableOption "strongswan-swanctl service";

    package = mkOption {
      type = types.package;
      default = pkgs.strongswan;
      defaultText = "pkgs.strongswan";
      description = ''
        The strongswan derivation to use.
      '';
    };

    strongswan.extraConfig = mkOption {
      type = types.str;
      default = "";
      description = ''
        Contents of the <literal>strongswan.conf</literal> file.
      '';
    };

    # The structured strongswan configuration is commented out for
    # now in favour of the literal config above. We should first
    # discus if we want to add the 600+ options by default.
    #strongswan = paramsToOptions strongswanParams;
    swanctl    = paramsToOptions swanctlParams;
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
      after    = [ "network-online.target" "keys.target" ];
      wants    = [ "keys.target" ];
      path = with pkgs; [ kmod iproute iptables utillinux ];
      environment.STRONGSWAN_CONF = pkgs.writeTextFile {
        name = "strongswan.conf";
        #text = paramsToConf cfg.strongswan strongswanParams;
        text = cfg.strongswan.extraConfig;
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
