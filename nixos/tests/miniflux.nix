import ./make-test-python.nix ({ pkgs, lib, ... }:

let
  port = 3142;
  username = "alice";
  password = "correcthorsebatterystaple";
  defaultPort = 8080;
  defaultUsername = "admin";
  defaultPassword = "password";
  adminCredentialsFile = pkgs.writeText "admin-credentials" ''
            ADMIN_USERNAME=${defaultUsername}
            ADMIN_PASSWORD=${defaultPassword}
          '';
  customAdminCredentialsFile = pkgs.writeText "admin-credentials" ''
            ADMIN_USERNAME=${username}
            ADMIN_PASSWORD=${password}
          '';

in
<<<<<<< HEAD
{
  name = "miniflux";
  meta.maintainers = [ ];
=======
with lib;
{
  name = "miniflux";
  meta.maintainers = with pkgs.lib.maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes = {
    default =
      { ... }:
      {
<<<<<<< HEAD
        security.apparmor.enable = true;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        services.miniflux = {
          enable = true;
          inherit adminCredentialsFile;
        };
      };

    withoutSudo =
      { ... }:
      {
<<<<<<< HEAD
        security.apparmor.enable = true;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        services.miniflux = {
          enable = true;
          inherit adminCredentialsFile;
        };
        security.sudo.enable = false;
      };

    customized =
      { ... }:
      {
<<<<<<< HEAD
        security.apparmor.enable = true;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        services.miniflux = {
          enable = true;
          config = {
            CLEANUP_FREQUENCY = "48";
            LISTEN_ADDR = "localhost:${toString port}";
          };
          adminCredentialsFile = customAdminCredentialsFile;
        };
      };
  };
  testScript = ''
    start_all()

    default.wait_for_unit("miniflux.service")
    default.wait_for_open_port(${toString defaultPort})
    default.succeed("curl --fail 'http://localhost:${toString defaultPort}/healthcheck' | grep OK")
    default.succeed(
        "curl 'http://localhost:${toString defaultPort}/v1/me' -u '${defaultUsername}:${defaultPassword}' -H Content-Type:application/json | grep '\"is_admin\":true'"
    )
<<<<<<< HEAD
    default.fail('journalctl -b --no-pager --grep "^audit: .*apparmor=\\"DENIED\\""')
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    withoutSudo.wait_for_unit("miniflux.service")
    withoutSudo.wait_for_open_port(${toString defaultPort})
    withoutSudo.succeed("curl --fail 'http://localhost:${toString defaultPort}/healthcheck' | grep OK")
    withoutSudo.succeed(
        "curl 'http://localhost:${toString defaultPort}/v1/me' -u '${defaultUsername}:${defaultPassword}' -H Content-Type:application/json | grep '\"is_admin\":true'"
    )
<<<<<<< HEAD
    withoutSudo.fail('journalctl -b --no-pager --grep "^audit: .*apparmor=\\"DENIED\\""')
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    customized.wait_for_unit("miniflux.service")
    customized.wait_for_open_port(${toString port})
    customized.succeed("curl --fail 'http://localhost:${toString port}/healthcheck' | grep OK")
    customized.succeed(
        "curl 'http://localhost:${toString port}/v1/me' -u '${username}:${password}' -H Content-Type:application/json | grep '\"is_admin\":true'"
    )
<<<<<<< HEAD
    customized.fail('journalctl -b --no-pager --grep "^audit: .*apparmor=\\"DENIED\\""')
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';
})
