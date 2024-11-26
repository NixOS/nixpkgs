import ./make-test-python.nix (
  { lib, ... }:
  let
    port = 5678;
    webhookUrl = "http://example.com";
  in
  {
    name = "n8n";
    meta.maintainers = with lib.maintainers; [
      freezeboy
      k900
    ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.n8n = {
          enable = true;
          webhookUrl = webhookUrl;
        };
      };

    testScript = ''
      machine.wait_for_unit("n8n.service")
      machine.wait_for_console_text("Editor is now accessible via")
      machine.succeed("curl --fail -vvv http://localhost:${toString port}/")
      machine.succeed("grep -qF ${webhookUrl} /etc/systemd/system/n8n.service")
    '';
  }
)
