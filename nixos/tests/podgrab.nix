let
  defaultPort = 8080;
  customPort = 4242;
in
import ./make-test-python.nix ({ pkgs, ... }: {
  name = "podgrab";

  nodes = {
    default = { ... }: {
      services.podgrab.enable = true;
    };

    customized = { ... }: {
      services.podgrab = {
        enable = true;
        port = customPort;
      };
    };
  };

  testScript = ''
    start_all()

    default.wait_for_unit("podgrab")
    default.wait_for_open_port(${toString defaultPort})
    default.succeed("curl --fail http://localhost:${toString defaultPort}")

    customized.wait_for_unit("podgrab")
    customized.wait_for_open_port(${toString customPort})
    customized.succeed("curl --fail http://localhost:${toString customPort}")
  '';

  meta.maintainers = with pkgs.lib.maintainers; [ ambroisie ];
})
