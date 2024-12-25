import ../make-test-python.nix (
  { ... }:
  {
    name = "tt-rss-nixos";

    nodes.machine =
      { pkgs, ... }:
      {
        services.tt-rss = {
          enable = true;
          virtualHost = "localhost";
          selfUrlPath = "http://localhost/";
          singleUserMode = true;
        };
      };

    testScript = ''
      machine.wait_for_unit("tt-rss.service")
      machine.succeed("curl -sSfL http://localhost/ | grep 'Tiny Tiny RSS'")
    '';
  }
)
