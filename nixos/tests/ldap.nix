import ./make-test.nix ({ pkgs, lib, ...} :

let
  unlines = lib.concatStringsSep "\n";
  unlinesAttrs = f: as: unlines (lib.mapAttrsToList f as);

  dbDomain = "example.com";
  dbSuffix = "dc=example,dc=com";
  dbAdminDn = "cn=admin,${dbSuffix}";
  dbAdminPwd = "admin-password";
  # NOTE: slappasswd -h "{SSHA}" -s '${dbAdminPwd}'
  dbAdminPwdHash = "{SSHA}i7FopSzkFQMrHzDMB1vrtkI0rBnwouP8";
  ldapUser = "test-ldap-user";
  ldapUserId = 10000;
  ldapUserPwd = "user-password";
  # NOTE: slappasswd -h "{SSHA}" -s '${ldapUserPwd}'
  ldapUserPwdHash = "{SSHA}v12XICMZNGT6r2KJ26rIkN8Vvvp4QX6i";
  ldapGroup = "test-ldap-group";
  ldapGroupId = 10000;

  mkClient = useDaemon:
    { lib, ... }:
    {
      virtualisation.memorySize = 256;
      virtualisation.vlans = [ 1 ];
      security.pam.services.su.rootOK = lib.mkForce false;
      users.ldap.enable = true;
      users.ldap.daemon = {
        enable = useDaemon;
        rootpwmoddn = "cn=admin,${dbSuffix}";
        rootpwmodpw = "/etc/nslcd.rootpwmodpw";
      };
      # NOTE: password stored in clear in Nix's store, but this is a test.
      environment.etc."nslcd.rootpwmodpw".source = pkgs.writeText "rootpwmodpw" dbAdminPwd;
      users.ldap.loginPam = true;
      users.ldap.nsswitch = true;
      users.ldap.server = "ldap://server";
      users.ldap.base = "ou=posix,${dbSuffix}";
      users.ldap.bind = {
        distinguishedName = "cn=admin,${dbSuffix}";
        password = "/etc/ldap/bind.password";
      };
      # NOTE: password stored in clear in Nix's store, but this is a test.
      environment.etc."ldap/bind.password".source = pkgs.writeText "password" dbAdminPwd;
    };
in

{
  name = "ldap";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ montag451 ];
  };

  nodes = {

    server =
      { pkgs, config, ... }:
      let
        inherit (config.services) openldap;

        slapdConfig = pkgs.writeText "cn=config.ldif" (''
          dn: cn=config
          objectClass: olcGlobal
          #olcPidFile: /run/slapd/slapd.pid
          # List of arguments that were passed to the server
          #olcArgsFile: /run/slapd/slapd.args
          # Read slapd-config(5) for possible values
          olcLogLevel: none
          # The tool-threads parameter sets the actual amount of CPU's
          # that is used for indexing.
          olcToolThreads: 1

          dn: olcDatabase={-1}frontend,cn=config
          objectClass: olcDatabaseConfig
          objectClass: olcFrontendConfig
          # The maximum number of entries that is returned for a search operation
          olcSizeLimit: 500
          # Allow unlimited access to local connection from the local root user
          olcAccess: to *
            by dn.exact=gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth manage
            by * break
          # Allow unauthenticated read access for schema and base DN autodiscovery
          olcAccess: to dn.exact=""
            by * read
          olcAccess: to dn.base="cn=Subschema"
            by * read

          dn: olcDatabase=config,cn=config
          objectClass: olcDatabaseConfig
          olcRootDN: cn=admin,cn=config
          #olcRootPW:
          # NOTE: access to cn=config, system root can be manager
          # with SASL mechanism (-Y EXTERNAL) over unix socket (-H ldapi://)
          olcAccess: to *
            by dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage
            by * break

          dn: cn=schema,cn=config
          objectClass: olcSchemaConfig

          include: file://${pkgs.openldap}/etc/schema/core.ldif
          include: file://${pkgs.openldap}/etc/schema/cosine.ldif
          include: file://${pkgs.openldap}/etc/schema/nis.ldif
          include: file://${pkgs.openldap}/etc/schema/inetorgperson.ldif

          dn: cn=module{0},cn=config
          objectClass: olcModuleList
          # Where the dynamically loaded modules are stored
          #olcModulePath: /usr/lib/ldap
          olcModuleLoad: back_mdb

          ''
          + unlinesAttrs (olcSuffix: {conf, ...}:
              "include: file://" + pkgs.writeText "config.ldif" conf
            ) slapdDatabases
          );

        slapdDatabases = {
          "${dbSuffix}" = {
            conf = ''
              dn: olcBackend={1}mdb,cn=config
              objectClass: olcBackendConfig

              dn: olcDatabase={1}mdb,cn=config
              olcSuffix: ${dbSuffix}
              olcDbDirectory: ${openldap.dataDir}/${dbSuffix}
              objectClass: olcDatabaseConfig
              objectClass: olcMdbConfig
              # NOTE: checkpoint the database periodically in case of system failure
              # and to speed up slapd shutdown.
              olcDbCheckpoint: 512 30
              # Database max size is 1G
              olcDbMaxSize: 1073741824
              olcLastMod: TRUE
              # NOTE: database superuser. Needed for syncrepl,
              # and used to auth as admin through a TCP connection.
              olcRootDN: cn=admin,${dbSuffix}
              olcRootPW: ${dbAdminPwdHash}
              #
              olcDbIndex: objectClass eq
              olcDbIndex: cn,uid eq
              olcDbIndex: uidNumber,gidNumber eq
              olcDbIndex: member,memberUid eq
              #
              olcAccess: to attrs=userPassword
                by self write
                by anonymous auth
                by dn="cn=admin,${dbSuffix}" write
                by dn="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" write
                by * none
              olcAccess: to attrs=shadowLastChange
                by self write
                by dn="cn=admin,${dbSuffix}" write
                by dn="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" write
                by * none
              olcAccess: to dn.sub="ou=posix,${dbSuffix}"
                by self read
                by dn="cn=admin,${dbSuffix}" read
                by dn="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read
              olcAccess: to *
                by self read
                by * none
            '';
            data = ''
              dn: ${dbSuffix}
              objectClass: top
              objectClass: dcObject
              objectClass: organization
              o: ${dbDomain}

              dn: cn=admin,${dbSuffix}
              objectClass: simpleSecurityObject
              objectClass: organizationalRole
              description: ${dbDomain} LDAP administrator
              roleOccupant: ${dbSuffix}
              userPassword: ${ldapUserPwdHash}

              dn: ou=posix,${dbSuffix}
              objectClass: top
              objectClass: organizationalUnit

              dn: ou=accounts,ou=posix,${dbSuffix}
              objectClass: top
              objectClass: organizationalUnit

              dn: ou=groups,ou=posix,${dbSuffix}
              objectClass: top
              objectClass: organizationalUnit
            ''
            + lib.concatMapStrings posixAccount [
              { uid=ldapUser; uidNumber=ldapUserId; gidNumber=ldapGroupId; userPassword=ldapUserPwdHash; }
            ]
            + lib.concatMapStrings posixGroup [
              { gid=ldapGroup; gidNumber=ldapGroupId; members=[]; }
            ];
          };
        };

        # NOTE: create a user account using the posixAccount objectClass.
        posixAccount =
          { uid
          , uidNumber ? null
          , gidNumber ? null
          , cn ? ""
          , sn ? ""
          , userPassword ? ""
          , loginShell ? "/bin/sh"
          }: ''

            dn: uid=${uid},ou=accounts,ou=posix,${dbSuffix}
            objectClass: person
            objectClass: posixAccount
            objectClass: shadowAccount
            cn: ${cn}
            gecos:
            ${if gidNumber == null then "#" else "gidNumber: ${toString gidNumber}"}
            homeDirectory: /home/${uid}
            loginShell: ${loginShell}
            sn: ${sn}
            ${if uidNumber == null then "#" else "uidNumber: ${toString uidNumber}"}
            ${if userPassword == "" then "#" else "userPassword: ${userPassword}"}
          '';

        # NOTE: create a group using the posixGroup objectClass.
        posixGroup =
          { gid
          , gidNumber
          , members
          }: ''

            dn: cn=${gid},ou=groups,ou=posix,${dbSuffix}
            objectClass: top
            objectClass: posixGroup
            gidNumber: ${toString gidNumber}
            ${lib.concatMapStrings (member: "memberUid: ${member}\n") members}
          '';
      in
      {
        virtualisation.memorySize = 256;
        virtualisation.vlans = [ 1 ];
        networking.firewall.allowedTCPPorts = [ 389 ];
        services.openldap.enable = true;
        services.openldap.dataDir = "/var/db/openldap";
        services.openldap.configDir = "/var/db/slapd";
        services.openldap.urlList = [
          "ldap:///"
          "ldapi:///"
        ];
        systemd.services.openldap = {
          preStart = ''
              set -e
              # NOTE: slapd's config is always re-initialized.
              rm -rf "${openldap.configDir}"/cn=config \
                     "${openldap.configDir}"/cn=config.ldif
              install -D -d -m 0700 -o "${openldap.user}" -g "${openldap.group}" "${openldap.configDir}"
              # NOTE: olcDbDirectory must be created before adding the config.
              '' +
              unlinesAttrs (olcSuffix: {data, ...}: ''
                # NOTE: database is always re-initialized.
                rm -rf "${openldap.dataDir}/${olcSuffix}"
                install -D -d -m 0700 -o "${openldap.user}" -g "${openldap.group}" \
                 "${openldap.dataDir}/${olcSuffix}"
                '') slapdDatabases
              + ''
              # NOTE: slapd is supposed to be stopped while in preStart,
              #       hence slap* commands can safely be used.
              umask 0077
              ${pkgs.openldap}/bin/slapadd -n 0 \
               -F "${openldap.configDir}" \
               -l ${slapdConfig}
              chown -R "${openldap.user}:${openldap.group}" "${openldap.configDir}"
              # NOTE: slapadd(8): To populate the config database slapd-config(5),
              #                   use -n 0 as it is always the first database.
              #                   It must physically exist on the filesystem prior to this, however.
            '' +
            unlinesAttrs (olcSuffix: {data, ...}: ''
              # NOTE: load database ${olcSuffix}
              # (as root to avoid depending on sudo or chpst)
              ${pkgs.openldap}/bin/slapadd \
               -F "${openldap.configDir}" \
               -l ${pkgs.writeText "data.ldif" data}
              '' + ''
              # NOTE: redundant with default openldap's preStart, but do not harm.
              chown -R "${openldap.user}:${openldap.group}" \
               "${openldap.dataDir}/${olcSuffix}"
            '') slapdDatabases;
        };
      };

    client1 = mkClient true; # use nss_pam_ldapd
    client2 = mkClient false; # use nss_ldap and pam_ldap

  };

  testScript = ''
    $server->start;
    $server->waitForUnit("default.target");

    subtest "slapd", sub {
      subtest "auth as database admin with SASL and check a POSIX account", sub {
        $server->succeed(join ' ', 'test',
         '"$(ldapsearch -LLL -H ldapi:// -Y EXTERNAL',
             '-b \'uid=${ldapUser},ou=accounts,ou=posix,${dbSuffix}\' ',
             '-s base uidNumber |',
           'sed -ne \'s/^uidNumber: \\(.*\\)/\\1/p\' ',
         ')" -eq ${toString ldapUserId}');
      };
      subtest "auth as database admin with password and check a POSIX account", sub {
        $server->succeed(join ' ', 'test',
         '"$(ldapsearch -LLL -H ldap://server',
             '-D \'cn=admin,${dbSuffix}\' -w \'${dbAdminPwd}\' ',
             '-b \'uid=${ldapUser},ou=accounts,ou=posix,${dbSuffix}\' ',
             '-s base uidNumber |',
           'sed -ne \'s/^uidNumber: \\(.*\\)/\\1/p\' ',
         ')" -eq ${toString ldapUserId}');
      };
    };

    $client1->start;
    $client1->waitForUnit("default.target");

    subtest "password", sub {
      subtest "su with password to a POSIX account", sub {
        $client1->succeed("${pkgs.expect}/bin/expect -c '" . join ';',
          'spawn su "${ldapUser}"',
          'expect "Password:"',
          'send "${ldapUserPwd}\n"',
          'expect "*"',
          'send "whoami\n"',
          'expect -ex "${ldapUser}" {exit}',
          'exit 1' . "'");
      };
      subtest "change password of a POSIX account as root", sub {
        $client1->succeed("chpasswd <<<'${ldapUser}:new-password'");
        $client1->succeed("${pkgs.expect}/bin/expect -c '" . join ';',
          'spawn su "${ldapUser}"',
          'expect "Password:"',
          'send "new-password\n"',
          'expect "*"',
          'send "whoami\n"',
          'expect -ex "${ldapUser}" {exit}',
          'exit 1' . "'");
        $client1->succeed('chpasswd <<<\'${ldapUser}:${ldapUserPwd}\' ');
      };
      subtest "change password of a POSIX account from itself", sub {
        $client1->succeed('chpasswd <<<\'${ldapUser}:${ldapUserPwd}\' ');
        $client1->succeed("${pkgs.expect}/bin/expect -c '" . join ';',
          'spawn su --login ${ldapUser} -c passwd',
          'expect "Password: "',
          'send "${ldapUserPwd}\n"',
          'expect "(current) UNIX password: "',
          'send "${ldapUserPwd}\n"',
          'expect "New password: "',
          'send "new-password\n"',
          'expect "Retype new password: "',
          'send "new-password\n"',
          'expect "passwd: password updated successfully" {exit}',
          'exit 1' . "'");
        $client1->succeed("${pkgs.expect}/bin/expect -c '" . join ';',
          'spawn su "${ldapUser}"',
          'expect "Password:"',
          'send "${ldapUserPwd}\n"',
          'expect "su: Authentication failure" {exit}',
          'exit 1' . "'");
        $client1->succeed("${pkgs.expect}/bin/expect -c '" . join ';',
          'spawn su "${ldapUser}"',
          'expect "Password:"',
          'send "new-password\n"',
          'expect "*"',
          'send "whoami\n"',
          'expect -ex "${ldapUser}" {exit}',
          'exit 1' . "'");
        $client1->succeed('chpasswd <<<\'${ldapUser}:${ldapUserPwd}\' ');
      };
    };

    $client2->start;
    $client2->waitForUnit("default.target");

    subtest "NSS", sub {
        $client1->succeed("test \"\$(id -u '${ldapUser}')\" -eq ${toString ldapUserId}");
        $client1->succeed("test \"\$(id -u -n '${ldapUser}')\" = '${ldapUser}'");
        $client1->succeed("test \"\$(id -g '${ldapUser}')\" -eq ${toString ldapGroupId}");
        $client1->succeed("test \"\$(id -g -n '${ldapUser}')\" = '${ldapGroup}'");
        $client2->succeed("test \"\$(id -u '${ldapUser}')\" -eq ${toString ldapUserId}");
        $client2->succeed("test \"\$(id -u -n '${ldapUser}')\" = '${ldapUser}'");
        $client2->succeed("test \"\$(id -g '${ldapUser}')\" -eq ${toString ldapGroupId}");
        $client2->succeed("test \"\$(id -g -n '${ldapUser}')\" = '${ldapGroup}'");
    };

    subtest "PAM", sub {
        $client1->succeed("echo ${ldapUserPwd} | su -l '${ldapUser}' -c true");
        $client2->succeed("echo ${ldapUserPwd} | su -l '${ldapUser}' -c true");
    };
  '';
})
