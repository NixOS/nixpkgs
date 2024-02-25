import ./make-test-python.nix ({ lib, ... }:

let
  ip = "127.0.0.1";
  port = 1234;
in
{
  name = "stash";
  meta.maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.stash = {
        enable = true;
        inherit ip port;
      };
    };

  testScript = ''
    machine.wait_for_unit("stash.service")
    machine.wait_for_open_port(${toString port}, "${ip}")
    machine.succeed("curl --fail http://${ip}:${toString port}/")
  '';
})
