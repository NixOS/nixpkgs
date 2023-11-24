{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.security.ipa;
  pyBool = x:
    if x
    then "True"
    else "False";

  ldapConf = pkgs.writeText "ldap.conf" ''
    # Turning this off breaks GSSAPI used with krb5 when rdns = false
    SASL_NOCANON    on

    URI ldaps://${cfg.server}
    BASE ${cfg.basedn}
    TLS_CACERT /etc/ipa/ca.crt
  '';
  nssDb =
    pkgs.runCommand "ipa-nssdb"
    {
      nativeBuildInputs = [pkgs.nss.tools];
    } ''
      mkdir -p $out
      certutil -d $out -N --empty-password
      certutil -d $out -A --empty-password -n "${cfg.realm} IPA CA" -t CT,C,C -i ${cfg.certificate}
    '';
in {
  options = {
    security.ipa = {
      enable = mkEnableOption (lib.mdDoc "FreeIPA domain integration");

      certificate = mkOption {
        type = types.package;
        description = lib.mdDoc ''
          IPA server CA certificate.

          Use `nix-prefetch-url http://$server/ipa/config/ca.crt` to
          obtain the file and the hash.
        '';
        example = literalExpression ''
          pkgs.fetchurl {
            url = http://ipa.example.com/ipa/config/ca.crt;
            sha256 = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
          };
        '';
      };

      domain = mkOption {
        type = types.str;
        example = "example.com";
        description = lib.mdDoc "Domain of the IPA server.";
      };

      realm = mkOption {
        type = types.str;
        example = "EXAMPLE.COM";
        description = lib.mdDoc "Kerberos realm.";
      };

      server = mkOption {
        type = types.str;
        example = "ipa.example.com";
        description = lib.mdDoc "IPA Server hostname.";
      };

      basedn = mkOption {
        type = types.str;
        example = "dc=example,dc=com";
        description = lib.mdDoc "Base DN to use when performing LDAP operations.";
      };

      offlinePasswords = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether to store offline passwords when the server is down.";
      };

      cacheCredentials = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether to cache credentials.";
      };

      ifpAllowedUids = mkOption {
        type = types.listOf types.str;
        default = ["root"];
        description = lib.mdDoc "A list of users allowed to access the ifp dbus interface.";
      };

      dyndns = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Whether to enable FreeIPA automatic hostname updates.";
        };

        interface = mkOption {
          type = types.str;
          example = "eth0";
          default = "*";
          description = lib.mdDoc "Network interface to perform hostname updates through.";
        };
      };

      chromiumSupport = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether to whitelist the FreeIPA domain in Chromium.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.krb5.enable;
        message = "krb5 must be disabled through `krb5.enable` for FreeIPA integration to work.";
      }
      {
        assertion = !config.users.ldap.enable;
        message = "ldap must be disabled through `users.ldap.enable` for FreeIPA integration to work.";
      }
    ];

    environment.systemPackages = with pkgs; [krb5Full freeipa];

    environment.etc = {
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

      "openldap/ldap.conf".source = ldapConf;
    };

    environment.etc."chromium/policies/managed/freeipa.json" = mkIf cfg.chromiumSupport {
      text = ''
        { "AuthServerWhitelist": "*.${cfg.domain}" }
      '';
    };

    system.activationScripts.ipa = stringAfter ["etc"] ''
      # libcurl requires a hard copy of the certificate
      if ! ${pkgs.diffutils}/bin/diff ${cfg.certificate} /etc/ipa/ca.crt > /dev/null 2>&1; then
        rm -f /etc/ipa/ca.crt
        cp ${cfg.certificate} /etc/ipa/ca.crt
      fi

      if [ ! -f /etc/krb5.keytab ]; then
        cat <<EOF

          In order to complete FreeIPA integration, please join the domain by completing the following steps:
          1. Authenticate as an IPA user authorized to join new hosts, e.g. kinit admin@${cfg.realm}
          2. Join the domain and obtain the keytab file: ipa-join
          3. Install the keytab file: sudo install -m 600 krb5.keytab /etc/
          4. Restart sssd systemd service: sudo systemctl restart sssd

      EOF
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
      ipa_hostname = ${config.networking.hostName}.${cfg.domain}

      cache_credentials = ${pyBool cfg.cacheCredentials}
      krb5_store_password_if_offline = ${pyBool cfg.offlinePasswords}
      ${optionalString ((toLower cfg.domain) != (toLower cfg.realm))
        "krb5_realm = ${cfg.realm}"}

      dyndns_update = ${pyBool cfg.dyndns.enable}
      dyndns_iface = ${cfg.dyndns.interface}

      ldap_tls_cacert = /etc/ipa/ca.crt
      ldap_user_extra_attrs = mail:mail, sn:sn, givenname:givenname, telephoneNumber:telephoneNumber, lock:nsaccountlock

      [sssd]
      debug_level = 65510
      services = nss, sudo, pam, ssh, ifp
      domains = ${cfg.domain}

      [nss]
      homedir_substring = /home

      [pam]
      pam_pwd_expiration_warning = 3
      pam_verbosity = 3

      [sudo]
      debug_level = 65510

      [autofs]

      [ssh]

      [pac]

      [ifp]
      user_attributes = +mail, +telephoneNumber, +givenname, +sn, +lock
      allowed_uids = ${concatStringsSep ", " cfg.ifpAllowedUids}
    '';

    services.ntp.servers = singleton cfg.server;
    services.sssd.enable = true;
    services.ntp.enable = true;

    security.pki.certificateFiles = singleton cfg.certificate;
  };
}
