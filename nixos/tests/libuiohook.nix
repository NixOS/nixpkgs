import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "libuiohook";
    meta = with lib.maintainers; {
      maintainers = [ anoa ];
    };

    nodes.client =
      { nodes, ... }:
      let
        user = nodes.client.config.users.users.alice;
      in
      {
        imports = [
          ./common/user-account.nix
          ./common/x11.nix
        ];

        environment.systemPackages = [ pkgs.libuiohook.test ];

        test-support.displayManager.auto.user = user.name;
      };

    testScript =
      { nodes, ... }:
      let
        user = nodes.client.config.users.users.alice;
      in
      ''
        client.wait_for_x()
        client.succeed("su - alice -c ${pkgs.libuiohook.test}/share/uiohook_tests >&2 &")
      '';
  }
)
