{ pkgs, ... }:
let
  dbContents = ''
    dn: dc=example
    objectClass: domain
    dc: example

    dn: ou=users,dc=example
    objectClass: organizationalUnit
    ou: users
  '';

  ldifConfig = ''
    dn: cn=config
    cn: config
    objectClass: olcGlobal
    olcLogLevel: stats

    dn: cn=schema,cn=config
    cn: schema
    objectClass: olcSchemaConfig

    include: file://${pkgs.openldap}/etc/schema/core.ldif
    include: file://${pkgs.openldap}/etc/schema/cosine.ldif
    include: file://${pkgs.openldap}/etc/schema/inetorgperson.ldif

    dn: olcDatabase={0}config,cn=config
    olcDatabase: {0}config
    objectClass: olcDatabaseConfig
    olcRootDN: cn=root,cn=config
    olcRootPW: configpassword

    dn: olcDatabase={1}mdb,cn=config
    objectClass: olcDatabaseConfig
    objectClass: olcMdbConfig
    olcDatabase: {1}mdb
    olcDbDirectory: /var/db/openldap
    olcDbIndex: objectClass eq
    olcSuffix: dc=example
    olcRootDN: cn=root,dc=example
    olcRootPW: notapassword
  '';

  ldapClientConfig = {
    enable = true;
    loginPam = false;
    nsswitch = false;
    server = "ldap://";
    base = "dc=example";
  };

in
{
  name = "openldap";

  nodes.machine =
    { config, pkgs, ... }:
    {
      environment.etc."openldap/root_password".text = "notapassword";

      users.ldap = ldapClientConfig;

      services.openldap = {
        enable = true;
        urlList = [
          "ldapi:///"
          "ldap://"
        ];
        settings = {
          children = {
            "cn=schema".includes = [
              "${pkgs.openldap}/etc/schema/core.ldif"
              "${pkgs.openldap}/etc/schema/cosine.ldif"
              "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
              "${pkgs.openldap}/etc/schema/nis.ldif"
            ];
            "olcDatabase={0}config" = {
              attrs = {
                objectClass = [ "olcDatabaseConfig" ];
                olcDatabase = "{0}config";
                olcRootDN = "cn=root,cn=config";
                olcRootPW = "configpassword";
              };
            };
            "olcDatabase={1}mdb" = {
              # This tests string, base64 and path values, as well as lists of string values
              attrs = {
                objectClass = [
                  "olcDatabaseConfig"
                  "olcMdbConfig"
                ];
                olcDatabase = "{1}mdb";
                olcDbDirectory = "/var/lib/openldap/db";
                olcSuffix = "dc=example";
                olcRootDN = {
                  # cn=root,dc=example
                  base64 = "Y249cm9vdCxkYz1leGFtcGxl";
                };
                olcRootPW = {
                  path = "/etc/openldap/root_password";
                };
              };
            };
          };
        };
      };

      specialisation = {
        declarativeContents.configuration =
          { ... }:
          {
            services.openldap.declarativeContents."dc=example" = dbContents;
          };
        mutableConfig.configuration =
          { ... }:
          {
            services.openldap = {
              declarativeContents."dc=example" = dbContents;
              mutableConfig = true;
            };
          };
        manualConfigDir = {
          inheritParentConfig = false;
          configuration =
            { ... }:
            {
              nixpkgs.hostPlatform = config.nixpkgs.hostPlatform;

              users.ldap = ldapClientConfig;
              services.openldap = {
                enable = true;
                configDir = "/var/db/slapd.d";
              };
            };
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      specializations = "${nodes.machine.system.build.toplevel}/specialisation";
      changeRootPw = ''
        dn: olcDatabase={1}mdb,cn=config
        changetype: modify
        replace: olcRootPW
        olcRootPW: foobar
      '';
    in
    ''
      # Test startup with empty DB
      machine.wait_for_unit("openldap.service")

      with subtest("declarative contents"):
        machine.succeed('${specializations}/declarativeContents/bin/switch-to-configuration test')
        machine.wait_for_unit("openldap.service")
        machine.succeed('ldapsearch -LLL -D "cn=root,dc=example" -w notapassword')
        machine.fail('ldapmodify -D cn=root,cn=config -w configpassword -f ${pkgs.writeText "rootpw.ldif" changeRootPw}')

      with subtest("mutable config"):
        machine.succeed('${specializations}/mutableConfig/bin/switch-to-configuration test')
        machine.succeed('ldapsearch -LLL -D "cn=root,dc=example" -w notapassword')
        machine.succeed('ldapmodify -D cn=root,cn=config -w configpassword -f ${pkgs.writeText "rootpw.ldif" changeRootPw}')
        machine.succeed('ldapsearch -LLL -D "cn=root,dc=example" -w foobar')

      with subtest("manual config dir"):
        machine.succeed(
          'mkdir /var/db/slapd.d /var/db/openldap',
          'slapadd -F /var/db/slapd.d -n0 -l ${pkgs.writeText "config.ldif" ldifConfig}',
          'slapadd -F /var/db/slapd.d -n1 -l ${pkgs.writeText "contents.ldif" dbContents}',
          'chown -R openldap:openldap /var/db/slapd.d /var/db/openldap',
          '${specializations}/manualConfigDir/bin/switch-to-configuration test',
        )
        machine.succeed('ldapsearch -LLL -D "cn=root,dc=example" -w notapassword')
        machine.succeed('ldapmodify -D cn=root,cn=config -w configpassword -f ${pkgs.writeText "rootpw.ldif" changeRootPw}')
        machine.succeed('ldapsearch -LLL -D "cn=root,dc=example" -w foobar')
    '';
}
