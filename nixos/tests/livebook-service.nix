import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "livebook-service";

  nodes = {
    machine = { config, pkgs, ... }: {
      imports = [
        ./common/user-account.nix
      ];

      services.livebook = {
        enableUserService = true;
        port = 20123;
        environmentFile = pkgs.writeText "livebook.env" ''
          LIVEBOOK_PASSWORD = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        '';
        options = {
          cookie = "chocolate chip";
        };
      };
    };
  };

  testScript = { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      sudo = lib.concatStringsSep " " [
        "XDG_RUNTIME_DIR=/run/user/${toString user.uid}"
        "sudo"
        "--preserve-env=XDG_RUNTIME_DIR"
        "-u"
        "alice"
      ];
    in
    ''
      machine.wait_for_unit("multi-user.target")

      machine.succeed("loginctl enable-linger alice")
      machine.wait_until_succeeds("${sudo} systemctl --user is-active livebook.service")
      machine.wait_for_open_port(20123)

      machine.succeed("curl -L localhost:20123 | grep 'Type password'")
    '';
})
