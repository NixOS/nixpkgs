import ./make-test-python.nix ({ pkgs, lib, ... }:

let
  port = 3142;
  username = "alice";
  password = "correcthorsebatterystaple";
  defaultPort = 8080;
  defaultUsername = "admin";
  defaultPassword = "password";
in
with lib;
{
  name = "miniflux";
  meta.maintainers = with pkgs.lib.maintainers; [ bricewge ];

  nodes = {
    default =
      { ... }:
      {
        services.miniflux.enable = true;
      };

    withoutSudo =
      { ... }:
      {
        services.miniflux.enable = true;
        security.sudo.enable = false;
      };

    customized =
      { ... }:
      {
        services.miniflux = {
          enable = true;
          config = {
            CLEANUP_FREQUENCY = "48";
            LISTEN_ADDR = "localhost:${toString port}";
          };
          adminCredentialsFile = pkgs.writeText "admin-credentials" ''
            ADMIN_USERNAME=${username}
            ADMIN_PASSWORD=${password}
          '';
        };
      };
  };
  testScript = ''
    start_all()

    default.wait_for_unit("miniflux.service")
    default.wait_for_open_port(${toString defaultPort})
    default.succeed("curl --fail 'http://localhost:${toString defaultPort}/healthcheck' | grep -q OK")
    default.succeed(
        "curl 'http://localhost:${toString defaultPort}/v1/me' -u '${defaultUsername}:${defaultPassword}' -H Content-Type:application/json | grep -q '\"is_admin\":true'"
    )

    withoutSudo.wait_for_unit("miniflux.service")
    withoutSudo.wait_for_open_port(${toString defaultPort})
    withoutSudo.succeed("curl --fail 'http://localhost:${toString defaultPort}/healthcheck' | grep -q OK")
    withoutSudo.succeed(
        "curl 'http://localhost:${toString defaultPort}/v1/me' -u '${defaultUsername}:${defaultPassword}' -H Content-Type:application/json | grep -q '\"is_admin\":true'"
    )

    customized.wait_for_unit("miniflux.service")
    customized.wait_for_open_port(${toString port})
    customized.succeed("curl --fail 'http://localhost:${toString port}/healthcheck' | grep -q OK")
    customized.succeed(
        "curl 'http://localhost:${toString port}/v1/me' -u '${username}:${password}' -H Content-Type:application/json | grep -q '\"is_admin\":true'"
    )
  '';
})
