{ lib, ... }:
let
  port = 5678;
  webhookUrl = "http://example.com";
  testSecret = "test-encryption-key-12345";
  secretFile = "n8n-test-secret";
in
{
  name = "n8n";
  meta.maintainers = with lib.maintainers; [ k900 ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.etc."${secretFile}".text = testSecret;

      services.n8n = {
        enable = true;
        environment = {
          WEBHOOK_URL = webhookUrl;
          N8N_ENCRYPTION_KEY_FILE = "/etc/${secretFile}";
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

    # Test _FILE environment variables
    machine.succeed("grep -qF 'LoadCredential=n8n_encryption_key_file:/etc/${secretFile}' /etc/systemd/system/n8n.service")
    machine.succeed("grep -qF 'N8N_ENCRYPTION_KEY_FILE=%d/n8n_encryption_key_file' /etc/systemd/system/n8n.service")
  '';
}
