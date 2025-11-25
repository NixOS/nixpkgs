let
  dbDomain = "example.org";
  dbSuffix = "dc=example,dc=org";

  ldapRootUser = "admin";
  ldapRootPassword = "foobar";

  testUser = "alice";
  testPassword = "foobar";
  testNewPassword = "barfoo";
in
import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "sssd-ldap";

    meta = with pkgs.lib.maintainers; {
      maintainers = [
        bbigras
        s1341
      ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        security.pam.services.systemd-user.makeHomeDir = true;
        environment.etc."cert.pem".text = builtins.readFile ./common/acme/server/acme.test.cert.pem;
        environment.etc."key.pem".text = builtins.readFile ./common/acme/server/acme.test.key.pem;
        services.openldap = {
          enable = true;
          urlList = [
            "ldap:///"
            "ldaps:///"
          ];
          settings = {
            attrs = {
              olcTLSCACertificateFile = "/etc/cert.pem";
              olcTLSCertificateFile = "/etc/cert.pem";
              olcTLSCertificateKeyFile = "/etc/key.pem";
              olcTLSCipherSuite = "HIGH:MEDIUM:+3DES:+RC4:+aNULL";
              olcTLSCRLCheck = "none";
              olcTLSVerifyClient = "never";
              olcTLSProtocolMin = "3.1";
            };
            children = {
              "cn=schema".includes = [
                "${pkgs.openldap}/etc/schema/core.ldif"
                "${pkgs.openldap}/etc/schema/cosine.ldif"
                "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
                "${pkgs.openldap}/etc/schema/nis.ldif"
              ];
              "olcDatabase={1}mdb" = {
                attrs = {
                  objectClass = [
                    "olcDatabaseConfig"
                    "olcMdbConfig"
                  ];
                  olcDatabase = "{1}mdb";
                  olcDbDirectory = "/var/lib/openldap/db";
                  olcSuffix = dbSuffix;
                  olcRootDN = "cn=${ldapRootUser},${dbSuffix}";
                  olcRootPW = ldapRootPassword;
                  olcAccess = [
                    # custom access rules for userPassword attributes
                    ''
                      {0}to attrs=userPassword
                                        by self write
                                        by anonymous auth
                                        by * none''

                    # allow read on anything else
                    ''
                      {1}to *
                                        by * read''
                  ];
                };
              };
            };
          };
          declarativeContents = {
            ${dbSuffix} = ''
              dn: ${dbSuffix}
              objectClass: top
              objectClass: dcObject
              objectClass: organization
              o: ${dbDomain}

              dn: ou=posix,${dbSuffix}
              objectClass: top
              objectClass: organizationalUnit

              dn: ou=accounts,ou=posix,${dbSuffix}
              objectClass: top
              objectClass: organizationalUnit

              dn: uid=${testUser},ou=accounts,ou=posix,${dbSuffix}
              objectClass: person
              objectClass: posixAccount
              userPassword: ${testPassword}
              homeDirectory: /home/${testUser}
              loginShell: /run/current-system/sw/bin/bash
              uidNumber: 1234
              gidNumber: 1234
              cn: ""
              sn: ""
            '';
          };
        };

        services.sssd = {
          enable = true;
          # just for testing purposes, don't put this into the Nix store in production!
          environmentFile = "${pkgs.writeText "ldap-root" "LDAP_BIND_PW=${ldapRootPassword}"}";
          settings = {
            sssd = {
              config_file_version = 2;
              services = "nss, pam, sudo";
              domains = dbDomain;
            };

            "domain/${dbDomain}" = {
              auth_provider = "ldap";
              id_provider = "ldap";
              ldap_uri = "ldaps://127.0.0.1:636";
              ldap_tls_reqcert = "allow";
              ldap_tls_cacert = "/etc/cert.pem";
              ldap_search_base = dbSuffix;
              ldap_default_bind_dn = "cn=${ldapRootUser},${dbSuffix}";
              ldap_default_authtok_type = "password";
              ldap_default_authtok = "$LDAP_BIND_PW";
            };
          };
        };
      };

    testScript = ''
      machine.start()
      machine.wait_for_unit("openldap.service")
      machine.wait_for_unit("sssd.service")
      result = machine.execute("getent passwd ${testUser}")
      if result[0] == 0:
        assert "${testUser}" in result[1]
      else:
        machine.wait_for_console_text("Backend is online")
        machine.succeed("getent passwd ${testUser}")

      with subtest("Log in as ${testUser}"):
          machine.wait_until_tty_matches("1", "login: ")
          machine.send_chars("${testUser}\n")
          machine.wait_until_tty_matches("1", "login: ${testUser}")
          machine.wait_until_succeeds("pgrep login")
          machine.wait_until_tty_matches("1", "Password: ")
          machine.send_chars("${testPassword}\n")
          machine.wait_until_succeeds("pgrep -u ${testUser} bash")
          machine.send_chars("touch done\n")
          machine.wait_for_file("/home/${testUser}/done")

      with subtest("Change ${testUser}'s password"):
          machine.send_chars("passwd\n")
          machine.wait_until_tty_matches("1", "Current Password: ")
          machine.send_chars("${testPassword}\n")
          machine.wait_until_tty_matches("1", "New Password: ")
          machine.send_chars("${testNewPassword}\n")
          machine.wait_until_tty_matches("1", "Reenter new Password: ")
          machine.send_chars("${testNewPassword}\n")
          machine.wait_until_tty_matches("1", "passwd: password updated successfully")

      with subtest("Log in as ${testUser} with new password in virtual console 2"):
          machine.send_key("alt-f2")
          machine.wait_until_succeeds("[ $(fgconsole) = 2 ]")
          machine.wait_for_unit("getty@tty2.service")
          machine.wait_until_succeeds("pgrep -f 'agetty.*tty2'")

          machine.wait_until_tty_matches("2", "login: ")
          machine.send_chars("${testUser}\n")
          machine.wait_until_tty_matches("2", "login: ${testUser}")
          machine.wait_until_succeeds("pgrep login")
          machine.wait_until_tty_matches("2", "Password: ")
          machine.send_chars("${testNewPassword}\n")
          machine.wait_until_succeeds("pgrep -u ${testUser} bash")
          machine.send_chars("touch done2\n")
          machine.wait_for_file("/home/${testUser}/done2")
    '';
  }
)
