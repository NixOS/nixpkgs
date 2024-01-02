{ pkgs, lib, ... }:
{
  name = "stargazer";
  meta = with lib.maintainers; { maintainers = [ gaykitty ]; };

  nodes = {
    geminiserver = { pkgs, ... }: {
      services.stargazer = {
        enable = true;
        routes = [
          {
            route = "localhost";
            root = toString (pkgs.writeTextDir "index.gmi" ''
              # Hello NixOS!
            '');
          }
        ];
      };
    };
  };

  testScript = { nodes, ... }: ''
    geminiserver.wait_for_unit("stargazer")
    geminiserver.wait_for_open_port(1965)

    with subtest("check is serving over gemini"):
      response = geminiserver.succeed("${pkgs.gemget}/bin/gemget --header -o - gemini://localhost:1965")
      print(response)
      assert "Hello NixOS!" in response
  '';
}
