{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "systemd-creds-basic";
  nodes.machine = { config, lib, pkgs, ... }: {
    
    
    security.artifacts.enable = true;
    security.artifacts.provider = "systemd-creds";
    security.artifacts.secrets."test-secret" = {};

    # Mock the systemd credential file since we can't easily run systemd-creds setup in a VM eval phase
    environment.etc."systemd/creds/test-secret.cred".text = "encrypted-mock-data";
  };

  testScript = ''
    machine.wait_for_unit("nixos-artifacts-secrets.target")
    # Verify the mock cred was placed in the target location
    machine.succeed("grep 'encrypted-mock-data' /run/secrets/test-secret")
  '';
}
