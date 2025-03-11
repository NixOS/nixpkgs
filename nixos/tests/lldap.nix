import ./make-test-python.nix (
  { ... }:
  {
    name = "lldap";

    nodes.machine =
      { pkgs, ... }:
      {
        services.lldap = {
          enable = true;
          settings = {
            verbose = true;
            ldap_base_dn = "dc=example,dc=com";
          };
        };
        environment.systemPackages = [ pkgs.openldap ];
      };

    testScript = ''
      machine.wait_for_unit("lldap.service")
      machine.wait_for_open_port(3890)
      machine.wait_for_open_port(17170)

      machine.succeed("curl --location --fail http://localhost:17170/")

      print(
        machine.succeed('ldapsearch -H ldap://localhost:3890 -D uid=admin,ou=people,dc=example,dc=com -b "ou=people,dc=example,dc=com" -w password')
      )
    '';
  }
)
