<<<<<<< HEAD
import ./make-test-python.nix ({ lib, ... }: {
  name = "readarr";
  meta.maintainers = with lib.maintainers; [ jocelynthode ];
=======
import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "readarr";
  meta.maintainers = with maintainers; [ jocelynthode ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine =
    { pkgs, ... }:
    { services.readarr.enable = true; };

  testScript = ''
    machine.wait_for_unit("readarr.service")
    machine.wait_for_open_port(8787)
    machine.succeed("curl --fail http://localhost:8787/")
  '';
})
