{ ... }:
let
  adminPassword = "mySecretPassword";
  alicePassword = "AlicePassword";
  bobPassword = "BobPassword";
  charliePassword = "CharliePassword";
in
{
  name = "lldap";

  nodes.machine =
    { pkgs, lib, ... }:
    {
      services.lldap = {
        enable = true;

        settings = {
          verbose = true;
          ldap_base_dn = "dc=example,dc=com";

          ldap_user_pass = "password";
        };
      };
      environment.systemPackages = [ pkgs.openldap ];

      specialisation = {
        differentAdminPassword.configuration =
          { ... }:
          {
            services.lldap.settings = {
              ldap_user_pass = lib.mkForce null;
              ldap_user_pass_file = toString (pkgs.writeText "adminPasswordFile" adminPassword);
              force_ldap_user_pass_reset = "always";
            };
          };

        changeAdminPassword.configuration =
          { ... }:
          {
            services.lldap.settings = {
              ldap_user_pass = lib.mkForce null;
              ldap_user_pass_file = toString (pkgs.writeText "adminPasswordFile" "password");
              force_ldap_user_pass_reset = false;
            };
          };

        withAlice.configuration =
          { ... }:
          {
            services.lldap = {
              enforceUsers = true;
              enforceUserMemberships = true;
              enforceGroups = true;

              # This password was set in the "differentAdminPassword" specialisation.
              ensureAdminPasswordFile = toString (pkgs.writeText "adminPasswordFile" adminPassword);

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
              enforceUsers = true;
              enforceUserMemberships = true;
              enforceGroups = true;

              # This time we check that ensureAdminPasswordFile correctly defaults to `settings.ldap_user_pass_file`
              settings = {
                ldap_user_pass = lib.mkForce "password";
                force_ldap_user_pass_reset = "always";
              };

              ensureUsers = {
                bob = {
                  email = "bob@example.com";
                  password_file = toString (pkgs.writeText "bobPasswordFile" bobPassword);
                  groups = [ "bobgroup" ];
                  displayName = "Bob";
                };
              };

              ensureGroups = {
                bobgroup = { };
              };
            };
          };

        withAttributes.configuration =
          { ... }:
          {
            services.lldap = {
              enforceUsers = true;
              enforceUserMemberships = true;
              enforceGroups = true;

              settings = {
                ldap_user_pass = lib.mkForce adminPassword;
                force_ldap_user_pass_reset = "always";
              };

              ensureUsers = {
                charlie = {
                  email = "charlie@example.com";
                  password_file = toString (pkgs.writeText "charliePasswordFile" charliePassword);
                  groups = [ "othergroup" ];
                  displayName = "Charlie";
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
      specialisations = "${nodes.machine.system.build.toplevel}/specialisation";
    in
    ''
      machine.wait_for_unit("lldap.service")
      machine.wait_for_open_port(3890)
      machine.wait_for_open_port(17170)

      machine.succeed("curl --location --fail http://localhost:17170/")

      adminPassword="${adminPassword}"
      alicePassword="${alicePassword}"
      bobPassword="${bobPassword}"
      charliePassword="${charliePassword}"

      def try_login(user, password, expect_success=True):
          cmd = f'ldapsearch -H ldap://localhost:3890 -D uid={user},ou=people,dc=example,dc=com -b "ou=people,dc=example,dc=com" -w {password}'
          code, response = machine.execute(cmd)
          print(cmd)
          print(response)
          if expect_success:
              if code != 0:
                  raise Exception(f"Expected success, had failure {code}")
          else:
              if code == 0:
                  raise Exception("Expected failure, had success")
          return response

      def parse_ldapsearch_output(output):
          return {n:v for (n, v) in (x.split(': ', 2) for x in output.splitlines() if x != "")}

      with subtest("default admin password"):
          try_login("admin", "password",    expect_success=True)
          try_login("admin", adminPassword, expect_success=False)

      with subtest("different admin password"):
          machine.succeed('${specialisations}/differentAdminPassword/bin/switch-to-configuration test')
          try_login("admin", "password",    expect_success=False)
          try_login("admin", adminPassword, expect_success=True)

      with subtest("change admin password has no effect"):
          machine.succeed('${specialisations}/differentAdminPassword/bin/switch-to-configuration test')
          try_login("admin", "password",    expect_success=False)
          try_login("admin", adminPassword, expect_success=True)

      with subtest("with alice"):
          machine.succeed('${specialisations}/withAlice/bin/switch-to-configuration test')
          try_login("alice", "password",    expect_success=False)
          try_login("alice", alicePassword, expect_success=True)
          try_login("bob",   "password",    expect_success=False)
          try_login("bob",   bobPassword,   expect_success=False)

      with subtest("with bob"):
          machine.succeed('${specialisations}/withBob/bin/switch-to-configuration test')
          try_login("alice", "password",    expect_success=False)
          try_login("alice", alicePassword, expect_success=False)
          try_login("bob",   "password",    expect_success=False)
          try_login("bob",   bobPassword,   expect_success=True)

      with subtest("with attributes"):
          machine.succeed('${specialisations}/withAttributes/bin/switch-to-configuration test')

          response = machine.succeed(f'ldapsearch -LLL -H ldap://localhost:3890 -D uid=admin,ou=people,dc=example,dc=com -b "dc=example,dc=com" -w {adminPassword} "(uid=charlie)"')
          print(response)
          charlie = parse_ldapsearch_output(response)
          if charlie.get('myattribute') != "2":
              raise Exception(f'Unexpected value for attribute "myattribute": {charlie.get('myattribute')}')

          response = machine.succeed(f'ldapsearch -LLL -H ldap://localhost:3890 -D uid=admin,ou=people,dc=example,dc=com -b "dc=example,dc=com" -w {adminPassword} "(cn=othergroup)"')
          print(response)
          othergroup = parse_ldapsearch_output(response)
          if othergroup.get('mygroupattribute') != "Managed by NixOS":
              raise Exception(f'Unexpected value for attribute "mygroupattribute": {othergroup.get('mygroupattribute')}')
    '';
}
