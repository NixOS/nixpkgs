import ./make-test-python.nix ({ lib, ... }:
<<<<<<< HEAD
  {
    name = "nzbhydra2";
    meta.maintainers = with lib.maintainers; [ jamiemagee ];
=======

  with lib;

  {
    name = "nzbhydra2";
    meta.maintainers = with maintainers; [ jamiemagee ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    nodes.machine = { pkgs, ... }: { services.nzbhydra2.enable = true; };

    testScript = ''
      machine.start()
      machine.wait_for_unit("nzbhydra2.service")
      machine.wait_for_open_port(5076)
      machine.succeed("curl --fail http://localhost:5076/")
    '';
  })
