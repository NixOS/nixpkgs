{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "dummy-multiple-secrets";

  nodes.machine = { ... }: {
    

    users.users.app = { isSystemUser = true; group = "app"; };
    users.groups.app = {};

    security.artifacts.enable = true;
    security.artifacts.provider = "dummy";
    security.artifacts.secrets = {
      "db-password" = {
        dummy = "pg-pass-123";
        owner = "app";
        group = "app";
        mode = "0400";
      };
      "api-key" = {
        dummy = "sk-test-abc";
        mode = "0440";
      };
      "tls-cert" = {
        dummy = "-----BEGIN CERTIFICATE-----";
        path = "/run/certs/tls.pem";
        mode = "0444";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("nixos-artifacts-secrets.target")

    # Secret 1: db-password
    result = machine.succeed("cat /run/secrets/db-password").strip()
    assert result == "pg-pass-123", f"db-password wrong: {result}"
    stat = machine.succeed("stat -c '%U %G %a' /run/secrets/db-password").strip()
    assert stat == "app app 400", f"db-password perms wrong: {stat}"

    # Secret 2: api-key
    result = machine.succeed("cat /run/secrets/api-key").strip()
    assert result == "sk-test-abc", f"api-key wrong: {result}"
    stat = machine.succeed("stat -c '%a' /run/secrets/api-key").strip()
    assert stat == "440", f"api-key perms wrong: {stat}"

    # Secret 3: tls-cert at custom path
    result = machine.succeed("cat /run/certs/tls.pem").strip()
    assert result == "-----BEGIN CERTIFICATE-----", f"tls-cert wrong: {result}"
  '';
}
