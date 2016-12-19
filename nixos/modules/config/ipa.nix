{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.ipa;
  sssd = config.services.sssd;
  ntp = config.services.ntp;
  krb5 = config.krb5;
  ldap = config.users.ldap;
  pyBool = x: if x then "True" else "False";

  ldapConf = pkgs.writeText "ldap.conf" ''
    # Turning this off breaks GSSAPI used with krb5 when rdns = false
    SASL_NOCANON    on

    URI ldaps://${cfg.server}
    BASE ${cfg.basedn}
    TLS_CACERT /etc/ipa/ca.crt
  '';
  nssDb = pkgs.runCommand "ipa-nssdb" { buildInputs = [ pkgs.nss.tools ]; } ''
    set -x
    mkdir -p $out
    < /dev/urandom tr -dc '[:print:]' | head -c 40 > $out/pwdfile.txt ||:
    chmod 600 $out/pwdfile.txt
    certutil -d $out -N -f $out/pwdfile.txt
    chmod 644 $out/*.db
    certutil -d $out -A -f $out/pwdfile -n "${cfg.realm} IPA CA" -t CT,C,C -i ${cfg.certificate}
  '';

in {
  options = {
    ipa = {
      enable = mkEnableOption "FreeIPA domain integration";

      certificate = mkOption {
        type = types.package;
        description = ''
          IPA server CA certificate.

          Use `nix-prefetch-url http://$server/ipa/config/ca.crt` to
          obtain the file and the hash.
        '';
      };

      domain = mkOption {
        type = types.str;
        example = "in.corp.com";
        description = "Domain of the IPA server.";
      };

      realm = mkOption {
        type = types.str;
        example = "IN.CORP.COM";
        description = "Kerberos realm.";
      };

      server = mkOption {
        type = types.str;
        example = "ipa.in.corp.com";
        description = "IPA Server hostname.";
      };

      basedn = mkOption {
        type = types.str;
        example = "dc=in,dc=corp,dc=com";
        description = "Base DN to use when performing LDAP operations.";
      };

      offlinePasswords = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to store offline passwords when the server is down.";
      };

      adminUser = mkOption {
        type = types.str;
        default = "admin";
        description = "IPA user with host joining privileges.";
      };

      dyndns = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable FreeIPA automatic hostname updates.";
        };

        interface = mkOption {
          type = types.str;
          example = "eth0";
          default = "*";
          description = "Network interface to perform hostname updates through.";
        };
      };

      chromiumSupport = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to whitelist the FreeIPA domain in Chromium.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = sssd.enable;
        message = "sssd must be enabled through `services.sssd.enable` for FreeIPA integration to work.";
      }
      {
        assertion = ntp.enable;
        message = "ntpd must be enabled through `services.ntp.enable` for FreeIPA integration to work.";
      }
      {
        assertion = !krb5.enable;
        message = "krb5 must be disabled through `krb5.enable` for FreeIPA integration to work.";
      }
      {
        assertion = !ldap.enable;
        message = "ldap must be disabled through `users.ldap.enable` for FreeIPA integration to work.";
      }
    ];

    environment.systemPackages = with pkgs; [ freeipa freeipaKerberos freeipaCurl freeipaBind.dnsutils openldap ];

    environment.etc = mkMerge [{
      "ipa/default.conf".text = ''
        [global]
        basedn = ${cfg.basedn}
        realm = ${cfg.realm}
        domain = ${cfg.domain}
        server = ${cfg.server}
        host = ${config.networking.hostName}
        xmlrpc_uri = https://${cfg.server}/ipa/xml
        enable_ra = True
      '';

      "ipa/nssdb".source = nssDb;

      "krb5.conf".text = ''
        [libdefaults]
         default_realm = ${cfg.realm}
         dns_lookup_realm = false
         dns_lookup_kdc = true
         rdns = false
         ticket_lifetime = 24h
         forwardable = true
         udp_preference_limit = 0

        [realms]
         ${cfg.realm} = {
          kdc = ${cfg.server}:88
          master_kdc = ${cfg.server}:88
          admin_server = ${cfg.server}:749
          default_domain = ${cfg.domain}
          pkinit_anchors = FILE:/etc/ipa/ca.crt
        }

        [domain_realm]
         .${cfg.domain} = ${cfg.realm}
         ${cfg.domain} = ${cfg.realm}
         ${cfg.server} = ${cfg.realm}

        [dbmodules]
          ${cfg.realm} = {
            db_library = ${pkgs.freeipa}/lib/krb5/plugins/kdb/ipadb.so
          }
      '';

      "opanldap/ldap.conf".source = ldapConf;
    }
    (mkIf cfg.chromiumSupport {
      "chromium/policies/managed/freeipa.json".text = ''
        { "AuthServerWhitelist": "*.${cfg.domain}" }
      '';
    })];

    system.activationScripts.ipa = stringAfter [ "etc" ] ''
      # libcurl requires a hard copy of the certificate
      if ! ${pkgs.diffutils}/bin/diff ${cfg.certificate} /etc/ipa/ca.crt > /dev/null 2>&1; then
        rm -f /etc/ipa/ca.crt
        cp ${cfg.certificate} /etc/ipa/ca.crt
      fi

      # Perform ipa-join after all files in /etc are available
      if [ ! -e /etc/krb5.keytab ]; then
        echo "Joining IPA domain ${cfg.domain}"
        ${pkgs.freeipaKerberos}/bin/kinit ${cfg.adminUser}@${cfg.realm} || exit 1
        ${pkgs.freeipa}/bin/ipa-join || exit 1
      fi
    '';

    services.sssd.config = ''
      [domain/${cfg.domain}]
      id_provider = ipa
      auth_provider = ipa
      access_provider = ipa
      chpass_provider = ipa

      ipa_domain = ${cfg.domain}
      ipa_server = _srv_, ${cfg.server}
      ipa_hostname = ${config.networking.hostName}

      cache_credentials = True
      krb5_store_password_if_offline = ${pyBool cfg.offlinePasswords}
      ${optionalString ((toLower cfg.domain) != (toLower cfg.realm))
        "krb5_realm = ${cfg.realm}"}

      dyndns_update = ${pyBool cfg.dyndns.enable}
      dyndns_iface = ${cfg.dyndns.interface}

      ldap_tls_cacert = /etc/ipa/ca.crt

      [sssd]
      services = nss, sudo, pam, ssh
      domains = ${cfg.domain}

      [nss]
      homedir_substring = /home

      [pam]

      [sudo]

      [autofs]

      [ssh]

      [pac]

      [ifp]
    '';

    services.ntp.servers = singleton cfg.server;
    security.pki.certificateFiles = singleton cfg.certificate;

  };
}
