{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "dummy-permissions";
  nodes.machine = { config, lib, ... }: {
    
    
    users.users.testuser = {
      isNormalUser = true;
      group = "testgroup";
    };
    users.groups.testgroup = {};

    security.artifacts.enable = true;
    security.artifacts.provider = "dummy";
    security.artifacts.secrets."test-secret" = {
      dummy = "secure-data";
      owner = "testuser";
      group = "testgroup";
      mode = "0600";
    };
  };

  testScript = ''
    machine.wait_for_unit("nixos-artifacts-secrets.target")
    # Verify owner and group
    stat_out = machine.succeed("stat -c '%U %G %a' /run/secrets/test-secret").strip()
    assert stat_out == "testuser testgroup 600", f"Unexpected stat output: {stat_out}"
  '';
}
