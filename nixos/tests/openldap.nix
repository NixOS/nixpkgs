{ pkgs ? (import ../.. { inherit system; config = { }; })
, system ? builtins.currentSystem
, ...
}:

let
  dbContents = ''
    dn: dc=example
    objectClass: domain
    dc: example

    dn: ou=users,dc=example
    objectClass: organizationalUnit
    ou: users
  '';
  testScript = ''
    machine.wait_for_unit("openldap.service")
    machine.succeed(
        'ldapsearch -LLL -D "cn=root,dc=example" -w notapassword -b "dc=example"',
    )
  '';
in {
  # New-style configuration
  current = import ./make-test-python.nix ({ pkgs, ... }: {
    inherit testScript;
    name = "openldap";

    nodes.machine = { pkgs, ... }: {
      environment.etc."openldap/root_password".text = "notapassword";
      services.openldap = {
        enable = true;
        settings = {
          children = {
            "cn=schema".includes = [
              "${pkgs.openldap}/etc/schema/core.ldif"
              "${pkgs.openldap}/etc/schema/cosine.ldif"
              "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
              "${pkgs.openldap}/etc/schema/nis.ldif"
            ];
            "olcDatabase={1}mdb" = {
              # This tests string, base64 and path values, as well as lists of string values
              attrs = {
                objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
                olcDatabase = "{1}mdb";
                olcDbDirectory = "/var/db/openldap";
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
        declarativeContents."dc=example" = dbContents;
      };
    };
  }) { inherit pkgs system; };

  # Old-style configuration
  oldOptions = import ./make-test-python.nix ({ pkgs, ... }: {
    inherit testScript;
    name = "openldap";

    nodes.machine = { pkgs, ... }: {
      services.openldap = {
        enable = true;
        logLevel = "stats acl";
        defaultSchemas = true;
        database = "mdb";
        suffix = "dc=example";
        rootdn = "cn=root,dc=example";
        rootpw = "notapassword";
        declarativeContents."dc=example" = dbContents;
      };
    };
  }) { inherit system pkgs; };

  # Manually managed configDir, for example if dynamic config is essential
  manualConfigDir = import ./make-test-python.nix ({ pkgs, ... }: {
    name = "openldap";

    nodes.machine = { pkgs, ... }: {
      services.openldap = {
        enable = true;
        configDir = "/var/db/slapd.d";
      };
    };

    testScript = let
      contents = pkgs.writeText "data.ldif" dbContents;
      config = pkgs.writeText "config.ldif" ''
        dn: cn=config
        cn: config
        objectClass: olcGlobal
        olcLogLevel: stats
        olcPidFile: /run/slapd/slapd.pid

        dn: cn=schema,cn=config
        cn: schema
        objectClass: olcSchemaConfig

        include: file://${pkgs.openldap}/etc/schema/core.ldif
        include: file://${pkgs.openldap}/etc/schema/cosine.ldif
        include: file://${pkgs.openldap}/etc/schema/inetorgperson.ldif

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
    in ''
      machine.succeed(
          "mkdir -p /var/db/slapd.d /var/db/openldap",
          "slapadd -F /var/db/slapd.d -n0 -l ${config}",
          "slapadd -F /var/db/slapd.d -n1 -l ${contents}",
          "chown -R openldap:openldap /var/db/slapd.d /var/db/openldap",
          "systemctl restart openldap",
      )
    '' + testScript;
  }) { inherit system pkgs; };
}
