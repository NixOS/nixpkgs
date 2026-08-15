{
  system ? builtins.currentSystem,
  pkgs ? import ../.. {
    inherit system;
    config = { };
  },
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
in
makeTest {
  name = "routinator";

  nodes.server =
    { pkgs, ... }:
    {
      services.routinator = {
        enable = true;
        extraArgs = [ "--no-rir-tals" ];
        settings = {
          http-listen = [ "[::]:8382" ];
        };
      };
    };

  testScript = ''
    start_all()

    server.wait_for_unit("routinator.service")

    with subtest("Check if routinator reports the correct version"):
      server.wait_until_succeeds("[[ \"$(curl http://localhost:8382/version)\" = \"${pkgs.routinator.version}\" ]]")
  '';
}
