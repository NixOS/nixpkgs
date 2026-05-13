{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "dummy-ordering";
  nodes.machine = { config, lib, pkgs, ... }: {
    
    
    security.artifacts.enable = true;
    security.artifacts.provider = "dummy";
    security.artifacts.secrets."test-secret" = {
      dummy = "ordered-data";
    };

    systemd.services.test-consumer = {
      description = "Consumer of secret";
      wantedBy = [ "multi-user.target" ];
      wants = [ "nixos-artifacts-secrets.target" ];
      after = [ "nixos-artifacts-secrets.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "consume" ''
          # This will fail if the secret doesn't exist yet
          cat /run/secrets/test-secret
        '';
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("test-consumer.service")
    machine.succeed("systemctl is-active test-consumer.service")
  '';
}
