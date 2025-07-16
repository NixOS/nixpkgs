{ ... }:
let
  adminPassword = "mySecretPassword";
  alicePassword = "AlicePassword";
  bobPassword = "BobPassword";
in
{
  name = "lldap";

  nodes.machine =
    { pkgs, ... }:
    {
      services.lldap = {
        enable = true;

        adminPasswordFile = toString (pkgs.writeText "adminPasswordFile" adminPassword);
        resetAdminPassword = "always";
        enforceEnsure = true;

        settings = {
          verbose = true;
          ldap_base_dn = "dc=example,dc=com";
        };

        ensureUsers = {
          alice = {
            email = "alice@example.com";
            password_file = toString (pkgs.writeText "alicePasswordFile" alicePassword);
            groups = [ "mygroup" ];
          };
        };

        ensureGroups = {
          mygroup = { };
        };
      };
      environment.systemPackages = [ pkgs.openldap ];

      specialisation = {
        withAlice.configuration =
          { ... }:
          {
            services.lldap = {
              ensureUsers = {
                alice = {
                  email = "alice@example.com";
                  password_file = toString (pkgs.writeText "alicePasswordFile" alicePassword);
                  groups = [ "mygroup" ];
                };
              };

              ensureGroups = {
                mygroup = { };
              };
            };
          };

        withBob.configuration =
          { ... }:
          {
            services.lldap = {
              ensureUsers = {
                bob = {
                  email = "bob@example.com";
                  password_file = toString (pkgs.writeText "bobPasswordFile" bobPassword);
                  groups = [ "othergroup" ];
                  displayName = "Bob";
                  myattribute = 2;
                };
              };

              ensureGroups = {
                othergroup = {
                  mygroupattribute = "Managed by NixOS";
                };
              };

              ensureUserFields = {
                myattribute = {
                  attributeType = "INTEGER";
                };
              };

              ensureGroupFields = {
                mygroupattribute = {
                  attributeType = "STRING";
                };
              };
            };
          };
      };
    };

  testScript =
    { nodes, ... }:
    let
      specializations = "${nodes.machine.system.build.toplevel}/specialisation";
    in
    ''
      machine.wait_for_unit("lldap.service")
      machine.wait_for_open_port(3890)
      machine.wait_for_open_port(17170)

      machine.succeed("curl --location --fail http://localhost:17170/")
      adminPassword="${adminPassword}"
      alicePassword="${alicePassword}"
      bobPassword="${bobPassword}"

      def try_login(user, password, expect_success=True):
          code, response = machine.execute(f'ldapsearch -H ldap://localhost:3890 -D uid={user},ou=people,dc=example,dc=com -b "ou=people,dc=example,dc=com" -w {password}')
          print(response)
          if expect_success:
              if code != 0:
                  raise Exception("Expected failure, had success")
          else:
              if code == 0:
                  raise Exception(f"Expected success, had failure {code}")

      with subtest("only default admin user"):
          print(try_login("admin", "password",    expect_success=False))
          print(try_login("admin", adminPassword, expect_success=True))
          print(try_login("alice", "password",    expect_success=False))
          print(try_login("alice", alicePassword, expect_success=False))
          print(try_login("bob",   "password",    expect_success=False))
          print(try_login("bob",   bobPassword,   expect_success=False))

      with subtest("with alice"):
          machine.succeed('${specializations}/withAlice/bin/switch-to-configuration test')
          print(try_login("admin", "password",    expect_success=False))
          print(try_login("admin", adminPassword, expect_success=True))
          print(try_login("alice", "password",    expect_success=False))
          print(try_login("alice", alicePassword, expect_success=True))
          print(try_login("bob",   "password",    expect_success=False))
          print(try_login("bob",   bobPassword,   expect_success=False))

      with subtest("with attributes"):
          machine.succeed('${specializations}/withBob/bin/switch-to-configuration test')
          print(try_login("admin", "password",    expect_success=False))
          print(try_login("admin", adminPassword, expect_success=True))
          print(try_login("alice", "password",    expect_success=False))
          print(try_login("alice", alicePassword, expect_success=False))
          print(try_login("bob",   "password",    expect_success=False))
          print(try_login("bob",   bobPassword,   expect_success=True))
    '';
}
