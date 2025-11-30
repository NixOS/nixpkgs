{ lib, ... }:
let
  port = 5678;
  webhookUrl = "http://example.com";
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
        environment.WEBHOOK_URL = webhookUrl;
      };
    };

  testScript = ''
    machine.wait_for_unit("n8n.service")
    machine.wait_for_console_text("Editor is now accessible via")
    machine.succeed("curl --fail -vvv http://localhost:${toString port}/")
    machine.succeed("grep -qF ${webhookUrl} /etc/systemd/system/n8n.service")
    machine.succeed("grep -qF 'HOME=/var/lib/n8n' /etc/systemd/system/n8n.service")
    machine.fail("grep -qF 'GENERIC_TIMEZONE=' /etc/systemd/system/n8n.service")
  '';
}
