{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "dummy-basic";

  nodes.machine = { ... }: {
    security.artifacts.enable = true;
    security.artifacts.provider = "dummy";
    security.artifacts.secrets."test-secret" = {
      dummy = "hello-world";
    };
  };

  testScript = ''
    machine.wait_for_unit("nixos-artifacts-secrets.target")
    result = machine.succeed("cat /run/secrets/test-secret").strip()
    assert result == "hello-world", f"Expected 'hello-world', got '{result}'"
  '';
}
