import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "xpadneo";
    meta.maintainers = with lib.maintainers; [ kira-bruneau ];

    nodes = {
      machine = {
        config.hardware.xpadneo.enable = true;
      };
    };

    # This is just a sanity check to make sure the module was
    # loaded. We'd have to find some way to mock an xbox controller if
    # we wanted more in-depth testing.
    testScript = ''
      machine.start();
      machine.succeed("modinfo hid_xpadneo | grep 'version:\s\+${pkgs.linuxPackages.xpadneo.version}'")
    '';
  }
)
