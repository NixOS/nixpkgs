{ pkgs, system ? builtins.currentSystem, ... }: let
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
  current = import ./make-test-python.nix {
    inherit testScript;
    name = "openldap";

    machine = { pkgs, ... }: {
      services.openldap = {
        enable = true;
        defaultSchemas = null;
        dataDir = null;
        database = null;
        settings = {
          children = {
            "cn=schema" = {
              includes = [
                "${pkgs.openldap}/etc/schema/core.ldif"
                "${pkgs.openldap}/etc/schema/cosine.ldif"
                "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
                "${pkgs.openldap}/etc/schema/nis.ldif"
              ];
            };
            "olcDatabase={1}mdb" = {
              attrs = {
                objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
                olcDatabase = "{1}mdb";
                olcDbDirectory = "/var/db/openldap";
                olcSuffix = "dc=example";
                olcRootDN = "cn=root,dc=example";
                olcRootPW = "notapassword";
              };
            };
          };
        };
        declarativeContents."dc=example" = dbContents;
      };
    };
  };

  # Old-style configuration
  shortOptions = import ./make-test-python.nix {
    inherit testScript;
    name = "openldap";

    machine = { pkgs, ... }: {
      services.openldap = {
        enable = true;
        suffix = "dc=example";
        rootdn = "cn=root,dc=example";
        rootpw = "notapassword";
        declarativeContents = dbContents;
      };
    };
  };

  # Manually managed configDir, for example if dynamic config is essential
  manualConfigDir = import ./make-test-python.nix {
    name = "openldap";

    machine = { pkgs, ... }: {
      services.openldap = {
        enable = true;
        configDir = "/var/db/slapd.d";
        # Silence warnings
        defaultSchemas = null;
        dataDir = null;
        database = null;
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
  };

  # extraConfig forces use of slapd.conf, test this until that option is removed
  legacyConfig = import ./make-test-python.nix {
    inherit testScript;
    name = "openldap";

    machine = { pkgs, ... }: {
      services.openldap = {
        enable = true;
        suffix = "dc=example";
        rootdn = "cn=root,dc=example";
        rootpw = "notapassword";
        extraConfig = ''
          # No-op
        '';
        extraDatabaseConfig = ''
          # No-op
        '';
        declarativeContents = dbContents;
      };
    };
  };
}
