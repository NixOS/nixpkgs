import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    port = 8082;
  in
  {
    name = "languagetool";
    meta = with lib.maintainers; {
      maintainers = [ fbeffa ];
    };

    nodes.machine =
      { ... }:
      {
        services.languagetool.enable = true;
        services.languagetool.port = port;
      };

    testScript = ''
      machine.start()
      machine.wait_for_unit("languagetool.service")
      machine.wait_for_open_port(${toString port})
      machine.wait_until_succeeds('curl -d "language=en-US" -d "text=a simple test" http://localhost:${toString port}/v2/check')
    '';
  }
)
