{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "dummy-ordering";

  nodes.machine = { ... }: {
    

    security.artifacts.enable = true;
    security.artifacts.provider = "dummy";
    security.artifacts.secrets."ordered-secret" = {
      dummy = "ordered-data";
    };

    # A consumer service that depends on the secret being available
    systemd.services.test-consumer = {
      description = "Consumer of nixos-artifacts secret";
      wantedBy = [ "multi-user.target" ];
      wants = [ "nixos-artifacts-secrets.target" ];
      after = [ "nixos-artifacts-secrets.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        # This will fail if the secret doesn't exist yet
        test -f /run/secrets/ordered-secret || exit 1
        cat /run/secrets/ordered-secret
      '';
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("systemctl is-active test-consumer.service")

    # Verify the consumer read the secret successfully
    result = machine.succeed("cat /run/secrets/ordered-secret").strip()
    assert result == "ordered-data", f"Wrong content: {result}"
  '';
}
