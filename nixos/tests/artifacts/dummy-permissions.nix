{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "dummy-permissions";

  nodes.machine = { ... }: {
    

    users.users.testuser = {
      isNormalUser = true;
      group = "testgroup";
    };
    users.groups.testgroup = {};

    security.artifacts.enable = true;
    security.artifacts.provider = "dummy";
    security.artifacts.secrets."perm-secret" = {
      dummy = "secure-data";
      owner = "testuser";
      group = "testgroup";
      mode = "0640";
    };
  };

  testScript = ''
    machine.wait_for_unit("nixos-artifacts-secrets.target")

    # Verify the file content
    result = machine.succeed("cat /run/secrets/perm-secret").strip()
    assert result == "secure-data", f"Wrong content: {result}"

    # Verify owner, group, and permissions
    stat = machine.succeed("stat -c '%U %G %a' /run/secrets/perm-secret").strip()
    assert stat == "testuser testgroup 640", f"Wrong permissions: {stat}"
  '';
}
