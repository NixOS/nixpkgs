import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "morty";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ leenaars ];
    };

    nodes = {
      mortyProxyWithKey =

        { ... }:
        {
          services.morty = {
            enable = true;
            key = "78a9cd0cfee20c672f78427efb2a2a96036027f0";
            port = 3001;
          };
        };

    };

    testScript =
      { ... }:
      ''
        mortyProxyWithKey.wait_for_unit("default.target")
        mortyProxyWithKey.wait_for_open_port(3001)
        mortyProxyWithKey.succeed("curl -fL 127.0.0.1:3001 | grep MortyProxy")
      '';

  }
)
