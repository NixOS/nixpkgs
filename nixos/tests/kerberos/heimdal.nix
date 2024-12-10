import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "kerberos_server-heimdal";

    nodes.machine =
      {
        config,
        libs,
        pkgs,
        ...
      }:
      {
        services.kerberos_server = {
          enable = true;
          realms = {
            "FOO.BAR".acl = [
              {
                principal = "admin";
                access = [
                  "add"
                  "cpw"
                ];
              }
            ];
          };
        };
        security.krb5 = {
          enable = true;
          package = pkgs.heimdal;
          settings = {
            libdefaults = {
              default_realm = "FOO.BAR";
            };
            realms = {
              "FOO.BAR" = {
                admin_server = "machine";
                kdc = "machine";
              };
            };
          };
        };
      };

    testScript = ''
      machine.succeed(
          "kadmin -l init --realm-max-ticket-life='8 day' --realm-max-renewable-life='10 day' FOO.BAR",
          "systemctl restart kadmind.service kdc.service",
      )

      for unit in ["kadmind", "kdc", "kpasswdd"]:
          machine.wait_for_unit(f"{unit}.service")

      machine.succeed(
          "kadmin -l add --password=admin_pw --use-defaults admin",
          "kadmin -l ext_keytab --keytab=admin.keytab admin",
          "kadmin -p admin -K admin.keytab add --password=alice_pw --use-defaults alice",
          "kadmin -l ext_keytab --keytab=alice.keytab alice",
          "kinit -kt alice.keytab alice",
      )
    '';

    meta.maintainers = [ pkgs.lib.maintainers.dblsaiko ];
  }
)
