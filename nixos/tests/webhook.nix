import ./make-test-python.nix ({ pkgs, ... }: {
  name = "webhook";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ymarkus ];
  };

  nodes = {
    webserver = { pkgs, lib, ... }: {
      services.webhook =
      let
        command = pkgs.writeScript "startDeployTimer" ''
          #! ${pkgs.runtimeShell}
          touch /tmp/testWebhook
        '';
      in {
        enable = true;
        settings = [{
          id = "testWebhook";
          execute-command = "${command}";
        }];
        user = "root";
      };
    };
  };

  testScript = { ... }: ''
    url = "http://localhost:9000/hooks/testWebhook"
    webserver.wait_for_unit("webhook")
    webserver.wait_for_open_port("9000")

    webserver.succeed("curl -fvvv -s http://localhost:9000/hooks/testWebhook")
    webserver.succeed("cat /tmp/testWebhook")
  '';

})
