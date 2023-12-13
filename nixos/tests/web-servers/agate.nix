{ pkgs, lib, ... }:
{
  name = "agate";
  meta = with lib.maintainers; { maintainers = [ jk ]; };

  nodes = {
    geminiserver = { pkgs, ... }: {
      services.agate = {
        enable = true;
        hostnames = [ "localhost" ];
        contentDir = pkgs.writeTextDir "index.gmi" ''
          # Hello NixOS!
        '';
      };
    };
  };

  testScript = { nodes, ... }: ''
    geminiserver.wait_for_unit("agate")
    geminiserver.wait_for_open_port(1965)

    with subtest("check is serving over gemini"):
      response = geminiserver.succeed("${pkgs.gemget}/bin/gemget --header -o - gemini://localhost:1965")
      print(response)
      assert "Hello NixOS!" in response
  '';
}
