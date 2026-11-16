{ lib, ... }:
{
  name = "zeroclaw";
  meta.maintainers = with lib.maintainers; [
    drupol
    nixosclaw
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.zeroclaw = {
        enable = true;
        settings = {
          default_provider = "ollama";
          default_model = "qwen3-coder-next:q4_K_M";
          api_url = "http://127.0.0.1:11434";
          # Test-only secret; a real deployment would use sops/agenix instead of
          # a file in the Nix store.
          api_key._secret = pkgs.writeText "zeroclaw-api-key" "test-secret-key-12345";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("zeroclaw.service")
    machine.wait_for_open_port(42617)

    # Verify config.toml exists with 0600 permissions and substituted secret
    perm = machine.succeed("stat -c '%a' /var/lib/zeroclaw/config.toml").strip()
    assert perm == "600", f"expected 0600 permissions, got {perm}"

    config = machine.succeed("cat /var/lib/zeroclaw/config.toml")
    assert "test-secret-key-12345" in config, "secret was not substituted into config.toml"
    assert "_secret" not in config, "_secret key leaked into config.toml"

    # Verify the gateway HTTP endpoint responds (including bundled web/dist)
    body = machine.succeed("curl --fail -s http://127.0.0.1:42617/")
    assert len(body) > 0, "expected non-empty HTTP response from zeroclaw gateway"
  '';
}
