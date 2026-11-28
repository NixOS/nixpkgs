{ lib, ... }:
{
  name = "lakefs";

  meta.maintainers = with lib.maintainers; [ philocalyst ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.lakefs = {
        enable = true;
        settings.installation = {
          user_name = "admin";
          access_key_id = "laketest";
          secret_access_key = "laketest-secret-access-key";
        };
      };

      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    machine.wait_for_unit("lakefs.service")
    machine.wait_for_open_port(8000)
    machine.succeed("curl --fail http://127.0.0.1:8000/_health")
    machine.succeed("curl --fail --location http://127.0.0.1:8000/ > /dev/null")
    machine.succeed("test -s /var/lib/lakefs/auth_encrypt_secret_key")
    machine.succeed("test -s /var/lib/lakefs/blockstore_signing_secret_key")
  '';
}
