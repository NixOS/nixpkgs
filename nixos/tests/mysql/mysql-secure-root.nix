{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
  lib ? pkgs.lib,
}:

let
  makeTest = import ./../make-test-python.nix;
  inherit (import ./common.nix { inherit pkgs lib; })
    mysqlPackages
    ;

  makeSecureRootTest =
    {
      package,
      name ? "mysql_secure_root_" + (builtins.replaceStrings [ "-" "." ] [ "_" "" ] package.pname),
    }:
    makeTest {
      inherit name;

      nodes.${name} = { pkgs, ... }: {
        services.mysql = {
          enable = true;
          package = package;
        };
      };

      testScript = ''
        start_all()

        machine = ${name}
        machine.wait_for_unit("mysql")

        # Verify that non-root user cannot connect as root
        machine.fail("sudo -u nobody mysql -u root -e 'SELECT 1;' 2>&1")

        # Verify that system root can connect as root via socket
        machine.succeed("mysql -u root -e 'SELECT 1;'")

        # Verify that root@localhost has auth_socket plugin
        machine.succeed("[ \"$(mysql -u root -N -e \"SELECT plugin FROM mysql.user WHERE user = 'root' AND host = 'localhost';\")\" = \"auth_socket\" ]")

        # Test service restart - verify it still works
        machine.succeed("systemctl restart mysql")
        machine.wait_for_unit("mysql")

        # After restart, verify non-root user still cannot connect as root
        machine.fail("sudo -u nobody mysql -u root -e 'SELECT 1;' 2>&1")

        # After restart, verify system root can still connect
        machine.succeed("mysql -u root -e 'SELECT 1;'")

        # After restart, verify root@localhost still has auth_socket
        machine.succeed("[ \"$(mysql -u root -N -e \"SELECT plugin FROM mysql.user WHERE user = 'root' AND host = 'localhost';\")\" = \"auth_socket\" ]")
      '';
    };

  makeInsecureRootTest =
    {
      package,
      name ? "mysql_insecure_root_" + (builtins.replaceStrings [ "-" "." ] [ "_" "" ] package.pname),
    }:
    makeTest {
      inherit name;

      nodes.${name} = { pkgs, ... }: {
        services.mysql = {
          enable = true;
          package = package;
          secureSuperUserByDefault = false;
        };
      };

      testScript = ''
        start_all()

        machine = ${name}
        machine.wait_for_unit("mysql")

        # With secureRootByDefault = false, anyone can connect as root (default --initialize-insecure behavior)
        machine.succeed("sudo -u nobody mysql -u root -e 'SELECT 1;' 2>&1")
      '';
    };

in
{
  "secure-by-default" = lib.mapAttrs (
    _: package: makeSecureRootTest { inherit package; }
  ) mysqlPackages;
  "can-be-insecure" = lib.mapAttrs (
    _: package: makeInsecureRootTest { inherit package; }
  ) mysqlPackages;
}
