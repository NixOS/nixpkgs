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
    ''
      user_name = "alice"

      start_all()

      local.succeed(f"loginctl enable-linger {user_name}")

      with subtest("Wait all VMs to be ready"):
          local.wait_for_unit("default.target")

      with subtest("Package is installed"):
          local.succeed(f"su - {user_name} --command 'command -v zellij'")

      with subtest("Server works localy"):
          local.wait_for_unit("zellij-web.service", user_name)
          local.succeed("curl --silent --show-error http://localhost:${toString port}/")
    '';
}
