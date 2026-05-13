{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "dummy-custom-path";

  nodes.machine = { ... }: {
    

    security.artifacts.enable = true;
    security.artifacts.provider = "dummy";
    security.artifacts.secrets."custom-path-secret" = {
      dummy = "custom-location";
      path = "/run/my-app/secrets/db-password";
    };
  };

  testScript = ''
    machine.wait_for_unit("nixos-artifacts-secrets.target")

    # Verify the custom path was used
    result = machine.succeed("cat /run/my-app/secrets/db-password").strip()
    assert result == "custom-location", f"Wrong content: {result}"

    # Verify default path does NOT exist
    machine.fail("test -f /run/secrets/custom-path-secret")
  '';
}
