{
  pkgs,
  ...
}:

let
  port = 8085;
in
{
  name = "zellij";

  nodes = {
    local = {
      imports = [
        ../common/user-account.nix
      ];

      services.zellij = {
        enable = true;
        user = "alice";
        web = {
          enable = true;
          port = port;
        };
      };

      environment.etc."zellij/config.kdl".text = ""; # without this, the server seems to not start in the test, but it seems to work in real world
    };
  };

  testScript =
    { nodes, ... }:
    builtins.readFile (
      pkgs.replaceVars ./test.py {
        user_name = "alice";
        port = port;
      }
    );
}
