{ lib, pkgs, ... }:
let
  port = 5678;
  webhookUrl = "http://example.com";
  secretFile = toString (pkgs.writeText "n8n-encryption-key" "test-encryption-key-12345");
in
{
  name = "n8n";
  meta.maintainers = with lib.maintainers; [ k900 ];

  node.pkgsReadOnly = false;

  nodes.machine =
    { ... }:
    {
      services.n8n = {
        enable = true;
        customNodes = [ pkgs.n8n-nodes-carbonejs ];
        environment = {
          WEBHOOK_URL = webhookUrl;
          N8N_TEMPLATES_ENABLED = false;
          DB_PING_INTERVAL_SECONDS = 2;
          # !!! Don't do this with real keys. The /nix store is world-readable!
          N8N_ENCRYPTION_KEY_FILE = secretFile;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("n8n.service")
    machine.wait_for_console_text("Editor is now accessible via")

    # Test regular environment variables
    machine.succeed("curl --fail -vvv http://localhost:${toString port}/")
    machine.succeed("grep -qF ${webhookUrl} /etc/systemd/system/n8n.service")
    machine.succeed("grep -qF 'HOME=/var/lib/n8n' /etc/systemd/system/n8n.service")
    machine.fail("grep -qF 'GENERIC_TIMEZONE=' /etc/systemd/system/n8n.service")
    machine.succeed("grep -qF 'N8N_DIAGNOSTICS_ENABLED=false' /etc/systemd/system/n8n.service")
    machine.succeed("grep -qF 'N8N_TEMPLATES_ENABLED=false' /etc/systemd/system/n8n.service")
    machine.succeed("grep -qF 'DB_PING_INTERVAL_SECONDS=2' /etc/systemd/system/n8n.service")

    # Test _FILE environment variables
    machine.succeed("grep -qF 'LoadCredential=n8n_encryption_key_file:${secretFile}' /etc/systemd/system/n8n.service")
    machine.succeed("grep -qF 'N8N_ENCRYPTION_KEY_FILE=%d/n8n_encryption_key_file' /etc/systemd/system/n8n.service")

    # Test custom nodes
    machine.succeed("grep -qF 'N8N_CUSTOM_EXTENSIONS=' /etc/systemd/system/n8n.service")
    custom_extensions_dir = machine.succeed("grep -oP 'N8N_CUSTOM_EXTENSIONS=\\K[^\"]+' /etc/systemd/system/n8n.service").strip()
    machine.succeed(f"test -L {custom_extensions_dir}/n8n-nodes-carbonejs")
    machine.succeed(f"test -f {custom_extensions_dir}/n8n-nodes-carbonejs/package.json")
  '';
}
