{ ... }:
let
  adminPassword = "mySecretPassword";
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
              ldap_user_pass_file = lib.mkForce (toString (pkgs.writeText "adminPasswordFile" adminPassword));
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

      with subtest("default admin password"):
          try_login("admin", "password",    expect_success=True)
          try_login("admin", adminPassword, expect_success=False)

      with subtest("different admin password"):
          machine.succeed('${specializations}/differentAdminPassword/bin/switch-to-configuration test')
          try_login("admin", "password",    expect_success=False)
          try_login("admin", adminPassword, expect_success=True)

      with subtest("change admin password has no effect"):
          machine.succeed('${specializations}/differentAdminPassword/bin/switch-to-configuration test')
          try_login("admin", "password",    expect_success=False)
          try_login("admin", adminPassword, expect_success=True)
    '';
}
