import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "livebook-service";

    nodes = {
      machine =
        { config, pkgs, ... }:
        {
          imports = [
            ./common/user-account.nix
          ];

          services.livebook = {
            enableUserService = true;
            environment = {
              LIVEBOOK_PORT = 20123;
            };
            environmentFile = pkgs.writeText "livebook.env" ''
              LIVEBOOK_PASSWORD = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            '';
          };

          users.users.alice.linger = true;
        };
    };

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
        runtimeUID = "$(id -u ${user.name})";
        sudo = lib.concatStringsSep " " [
          "XDG_RUNTIME_DIR=/run/user/${runtimeUID}"
          "sudo"
          "--preserve-env=XDG_RUNTIME_DIR"
          "-u"
          user.name
        ];
      in
      ''
        machine.wait_for_unit("multi-user.target")

        machine.wait_for_unit("user@${runtimeUID}")
        machine.wait_for_unit("livebook.service", "${user.name}")
        machine.wait_for_open_port(20123, timeout=10)

        machine.succeed("curl -L localhost:20123 | grep 'Type password'")
      '';
  }
)
