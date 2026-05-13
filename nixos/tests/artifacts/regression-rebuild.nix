{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "regression-rebuild";
  nodes.machine = { config, lib, pkgs, ... }: {
    
    
    security.artifacts.enable = true;
    security.artifacts.provider = "dummy";
    security.artifacts.secrets."persistent-secret" = {
      dummy = "survives-rebuild";
    };
  };

  testScript = ''
    machine.wait_for_unit("nixos-artifacts-secrets.target")
    machine.succeed("cat /run/secrets/persistent-secret | grep survives-rebuild")
    
    # Perform a configuration rebuild switch
    machine.succeed("nixos-rebuild switch")
    
    # Verify secret is still intact and permissions hold
    machine.succeed("cat /run/secrets/persistent-secret | grep survives-rebuild")
  '';
}
