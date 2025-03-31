import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "watchdogd";
    meta.maintainers = with lib.maintainers; [ vifino ];

    nodes.machine =
      { pkgs, ... }:
      {
        virtualisation.qemu.options = [
          "-device i6300esb" # virtual watchdog timer
        ];
        boot.kernelModules = [ "i6300esb" ];
        services.watchdogd.enable = true;
        services.watchdogd.settings = {
          supervisor.enabled = true;
        };
      };

    testScript = ''
      machine.wait_for_unit("watchdogd.service")

      assert "i6300ESB" in machine.succeed("watchdogctl status")
      machine.succeed("watchdogctl test")
    '';
  }
)
