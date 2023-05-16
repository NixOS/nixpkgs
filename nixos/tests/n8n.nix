import ./make-test-python.nix ({ lib, ... }:
<<<<<<< HEAD
let
  port = 5678;
  webhookUrl = "http://example.com";
in
{
  name = "n8n";
  meta.maintainers = with lib.maintainers; [ freezeboy k900 ];
=======

with lib;

let
  port = 5678;
in
{
  name = "n8n";
  meta.maintainers = with maintainers; [ freezeboy k900 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine =
    { pkgs, ... }:
    {
      services.n8n = {
        enable = true;
<<<<<<< HEAD
        webhookUrl = webhookUrl;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };

  testScript = ''
    machine.wait_for_unit("n8n.service")
    machine.wait_for_console_text("Editor is now accessible via")
    machine.succeed("curl --fail -vvv http://localhost:${toString port}/")
<<<<<<< HEAD
    machine.succeed("grep -qF ${webhookUrl} /etc/systemd/system/n8n.service")
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';
})
