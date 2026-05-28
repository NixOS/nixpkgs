{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "dummy-idempotency";

  nodes.machine = { ... }: {
    

    security.artifacts.enable = true;
    security.artifacts.provider = "dummy";
    security.artifacts.secrets."idem-secret" = {
      dummy = "idempotent-value";
      mode = "0400";
    };
  };

  testScript = ''
    machine.wait_for_unit("nixos-artifacts-secrets.target")

    # Record the initial state
    result1 = machine.succeed("cat /run/secrets/idem-secret").strip()
    stat1 = machine.succeed("stat -c '%a %U %G' /run/secrets/idem-secret").strip()
    inode1 = machine.succeed("stat -c '%i' /run/secrets/idem-secret").strip()

    assert result1 == "idempotent-value", f"Initial content wrong: {result1}"
    assert stat1 == "400 root root", f"Initial perms wrong: {stat1}"

    # Restart the provisioning service (simulates a rebuild)
    machine.succeed("systemctl restart nixos-artifacts-dummy-idem-secret.service")

    # Verify content and permissions are preserved
    result2 = machine.succeed("cat /run/secrets/idem-secret").strip()
    stat2 = machine.succeed("stat -c '%a %U %G' /run/secrets/idem-secret").strip()

    assert result2 == "idempotent-value", f"Post-restart content wrong: {result2}"
    assert stat2 == "400 root root", f"Post-restart perms wrong: {stat2}"
  '';
}
