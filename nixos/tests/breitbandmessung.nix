{ lib, ... }:
{
  name = "breitbandmessung";
  meta.maintainers = with lib.maintainers; [ b4dm4n ];

  node.pkgsReadOnly = false;

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];

      # increase screen size to make the whole program visible
      virtualisation.resolution = {
        x = 1280;
        y = 1024;
      };

      test-support.displayManager.auto.user = "alice";

      environment.systemPackages = with pkgs; [ breitbandmessung ];
      environment.variables.XAUTHORITY = "/home/alice/.Xauthority";
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()
    machine.execute("su - alice -c breitbandmessung >&2  &")
    machine.wait_for_window("Breitbandmessung")
    machine.wait_for_text("Breitbandmessung")
    machine.wait_for_text("Datenschutz")
    machine.screenshot("breitbandmessung")
  '';
}
