{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "systemd-creds-basic";

  nodes.machine = { ... }: {
    

    security.artifacts.enable = true;
    security.artifacts.provider = "systemd-creds";
    security.artifacts.secrets."cred-secret" = {};

    # Mock the credential file at the expected location.
    # In production, this would be an encrypted credential created with
    # `systemd-creds encrypt`.
    environment.etc."credstore/cred-secret".text = "credential-mock-data";
  };

  testScript = ''
    machine.wait_for_unit("nixos-artifacts-secrets.target")

    result = machine.succeed("cat /run/secrets/cred-secret").strip()
    assert result == "credential-mock-data", f"Wrong content: {result}"

    # Verify default permissions
    stat = machine.succeed("stat -c '%U %G %a' /run/secrets/cred-secret").strip()
    assert stat == "root root 400", f"Wrong permissions: {stat}"
  '';
}
