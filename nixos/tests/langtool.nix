import ./make-test-python.nix ({ pkgs, ... }:

  {
    name = "languagetool-http";
    machine = {
      services.languageToolHttp.enable = true;
      environment.systemPackages = [ pkgs.curl ];
    };

    testScript = ''
      machine.start()
      machine.wait_for_open_port(8081)
      machine.succeed('curl -d "language=en-US" -d "text=a simple test" http://localhost:8081/v2/check')
    '';
  })
