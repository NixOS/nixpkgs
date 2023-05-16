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
<<<<<<< HEAD
      response = geminiserver.succeed("${pkgs.gemget}/bin/gemget --header -o - gemini://localhost:1965")
=======
      response = geminiserver.succeed("${pkgs.gmni}/bin/gmni -j once -i -N gemini://localhost:1965")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      print(response)
      assert "Hello NixOS!" in response
  '';
}
