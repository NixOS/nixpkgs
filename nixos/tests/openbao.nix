{ lib, ... }:
let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
{
  name = "openbao";

  meta.maintainers = with lib.maintainers; [ kranzes ];

  nodes.machine =
    { config, ... }:
    {

      security.pki.certificateFiles = [ certs.ca.cert ];

      networking.extraHosts = ''
        127.0.0.1 ${domain}
      '';

      services.openbao = {
        enable = true;
        settings = {
          listener.tcp = {
            tls_cert_file = certs.${domain}.cert;
            tls_key_file = certs.${domain}.key;
          };

          cluster_addr = "https://127.0.0.1:8201";
          api_addr = "https://${domain}:8200";

          storage.raft = {
            path = "/var/lib/openbao";
            node_id = config.networking.hostName;
          };
        };
      };

      environment.variables = {
        BAO_ADDR = config.services.openbao.settings.api_addr;
        BAO_FORMAT = "json";
      };
    };

  testScript = ''
    import json

    start_all()

    with subtest("Wait for OpenBao to start up"):
      machine.wait_for_unit("openbao.service")
      machine.wait_for_open_port(8200)

    with subtest("Check that OpenBao is not initialized"):
      status_output = json.loads(machine.fail("bao status"))
      assert not status_output.get("initialized")

    with subtest("Initialize OpenBao"):
      init_output = json.loads(machine.succeed("bao operator init"))

    with subtest("Check that OpenBao is initialized and sealed"):
      status_output = json.loads(machine.fail("bao status"))
      assert status_output.get("initialized")
      assert status_output.get("sealed")

    with subtest("Unseal OpenBao"):
      for key in init_output.get("unseal_keys_b64")[:init_output.get("unseal_threshold")]:
        machine.succeed(f"bao operator unseal {key}")

    with subtest("Check that OpenBao is not sealed"):
      status_output = json.loads(machine.succeed("bao status"))
      assert not status_output.get("sealed")

    with subtest("Login with root token"):
      machine.succeed(f"bao login {init_output.get("root_token")}")

    with subtest("Enable userpass auth method"):
      machine.succeed("bao auth enable userpass")

    with subtest("Create a user in userpass"):
      machine.succeed("bao write auth/userpass/users/testuser password=testpassword")

    with subtest("Login to a user from userpass"):
      machine.succeed("bao login -method userpass username=testuser password=testpassword")

    with subtest("Write a secret to cubbyhole"):
      machine.succeed("bao write cubbyhole/my-secret my-value=s3cr3t")

    with subtest("Read a secret from cubbyhole"):
      read_output = json.loads(machine.succeed("bao read cubbyhole/my-secret"))
      assert read_output.get("data").get("my-value") == "s3cr3t"
  '';
}
