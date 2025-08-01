import ../../make-test-python.nix (
  { pkgs, ... }:
  let
    DITRoot = "dc=example,dc=com";
    realm = "EXAMPLE.COM";

    krb5Package = pkgs.krb5.override { withLdap = true; };

    # Password used by Kerberos services to bind to their identities
    krbSrvPwd = "kerberos_service_password";
    # Stash file read by Kerberos daemons containing the service password
    # DO NOT DO THIS IN PRODUCTION! The stash file is a fundamental secret!
    krbPwdStash = pkgs.runCommand "krb-pwd-stash" { } ''
      for srv in cn=kadmin,${DITRoot} cn=kdc,${DITRoot}
      do
        echo -e "${krbSrvPwd}\n${krbSrvPwd}" | \
             ${krb5Package}/bin/kdb5_ldap_util -r ${realm} stashsrvpw -f $out $srv 2>&1 > /dev/null
      done
    '';

    # The LDAP schema for Kerberos 5 objects is part of the source distribution of Kerberos 5
    krbLdapSchema = pkgs.runCommand "krb-ldap-schema" { } ''
      tar -Oxf ${krb5Package.src} \
        ${krb5Package.sourceRoot}/plugins/kdb/ldap/libkdb_ldap/kerberos.openldap.ldif > $out
    '';

    # Initial LDAP tree containing only the Kerberos services
    ldapDIT = ''
      dn: ${DITRoot}
      objectClass: organization
      objectClass: dcObject
      dc: example
      o: Example Company

      dn: cn=kdc,${DITRoot}
      objectClass: krbKdcService
      objectClass: simpleSecurityObject
      cn: kdc
      userPassword: ${krbSrvPwd}

      dn: cn=kadmin,${DITRoot}
      objectClass: krbAdmService
      objectClass: simpleSecurityObject
      cn: kadmin
      userPassword: ${krbSrvPwd}
    '';

    rootDnPwd = "ldap_root_password";
  in
  {
    name = "kerberos_server-mit-ldap";

    nodes.machine =
      { pkgs, ... }:
      {

        services.openldap = {
          enable = true;
          urlList = [
            "ldapi:///"
            "ldap://"
          ];
          declarativeContents."${DITRoot}" = ldapDIT;
          settings = {
            children = {
              "cn=schema".includes = [
                "${pkgs.openldap}/etc/schema/core.ldif"
                "${pkgs.openldap}/etc/schema/cosine.ldif"
                "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
                "${pkgs.openldap}/etc/schema/nis.ldif"
                "${krbLdapSchema}"
              ];
              "olcDatabase={0}config" = {
                attrs = {
                  objectClass = [ "olcDatabaseConfig" ];
                  olcDatabase = "{0}config";
                };
              };
              "olcDatabase={1}mdb" = {
                attrs = {
                  objectClass = [
                    "olcDatabaseConfig"
                    "olcMdbConfig"
                  ];
                  olcDatabase = "{1}mdb";
                  olcDbDirectory = "/var/lib/openldap/db";
                  olcSuffix = DITRoot;
                  olcRootDN = "cn=root,${DITRoot}";
                  olcRootPW = rootDnPwd;
                  # A tiny but realistic ACL
                  olcAccess = [
                    ''
                      to attrs=userPassword
                                          by anonymous auth
                                          by * none''
                    ''
                      to dn.subtree="cn=${realm},cn=realms,${DITRoot}"
                                          by dn.exact="cn=kdc,${DITRoot}" write
                                          by dn.exact="cn=kadmin,${DITRoot}" write
                                          by * none''
                    ''
                      to *
                                          by * read''
                  ];
                };
              };
            };
          };
        };

        services.kerberos_server = {
          enable = true;
          settings = {
            libdefaults.default_realm = realm;
            realms = {
              "${realm}" = {
                acl = [
                  {
                    principal = "admin";
                    access = "all";
                  }
                ];
              };
            };
            dbmodules = {
              "${realm}" = {
                db_library = "kldap";
                ldap_kerberos_container_dn = "cn=realms,${DITRoot}";
                ldap_kdc_dn = "cn=kdc,${DITRoot}";
                ldap_kadmind_dn = "cn=kadmin,${DITRoot}";
                ldap_service_password_file = toString krbPwdStash;
                ldap_servers = "ldapi:///";
              };
            };
          };
        };

        security.krb5 = {
          enable = true;
          package = krb5Package;
          settings = {
            libdefaults = {
              default_realm = realm;
            };
            realms = {
              "${realm}" = {
                admin_server = "machine";
                kdc = "machine";
              };
            };
          };
        };

        users.extraUsers.alice = {
          isNormalUser = true;
        };
      };

    testScript = ''
      machine.wait_for_unit("openldap.service")

      with subtest("realm container initialization"):
          machine.succeed(
              # Passing a master key directly avoids the need for a separate master key stash file
              "kdb5_ldap_util -D cn=root,${DITRoot} create -w ${rootDnPwd} -s -P master_key",
          )

      # These units are bound to fail, as they are started before the directory service is ready
      machine.execute("systemctl restart kadmind.service kdc.service")

      with subtest("service bind"):
           for unit in ["kadmind", "kdc"]:
               machine.wait_for_unit(f"{unit}.service")

      with subtest("administration principal initialization"):
           machine.succeed("kadmin.local add_principal -pw admin_pw admin")

      with subtest("user principal creation and kinit"):
           machine.succeed(
               "kadmin -p admin -w admin_pw addprinc -pw alice_pw alice",
               "echo alice_pw | sudo -u alice kinit",
           )
           # Make extra sure that the user principal actually exists in the directory
           machine.succeed(
             "ldapsearch -x -D cn=root,${DITRoot} -w ${rootDnPwd} \
               -b ${DITRoot} 'krbPrincipalName=alice@${realm}' | grep 'numEntries: 1'"
           )
    '';

    meta.maintainers = [ pkgs.lib.maintainers.nessdoor ];
  }
)
