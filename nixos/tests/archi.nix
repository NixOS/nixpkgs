{ pkgs, ... }:
{
  name = "archi";
  meta = { inherit (pkgs.archi.meta) maintainers platforms; };

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [
        ./common/x11.nix
      ];

      environment.systemPackages = with pkgs; [ archi ];
    };

  testScript = ''
    machine.wait_for_x()

    with subtest("create a model from the command line"):
        machine.succeed(
            "archi -application com.archimatetool.commandline.app -consoleLog -nosplash"
            " --createEmptyModel --saveModel smoke.archimate"
        )
        machine.succeed("grep -q 'archimate:model' smoke.archimate")

    # Waiting for the welcome text with OCR would be preferable but it hangs
    # indefinitely on this screen, see: https://github.com/NixOS/nixpkgs/issues/302965
    with subtest("the workbench comes up"):
        machine.succeed("DISPLAY=:0 archi >&2 &")
        # The first window to appear is the splash screen, so it says nothing
        # about the workbench.
        machine.wait_for_window("Archi")

        # SWT maps this native only when it brings up a display, so wait for
        # that. The launcher forks a JVM and stays around, so match on the
        # launcher jar to get the JVM rather than the launcher itself. The
        # bracket stops pgrep from matching the shell running the check.
        machine.wait_until_succeeds(
            'grep -q "libswt-pi3-gtk" "/proc/$(pgrep -f "equinox[.]launcher_")/maps"'
        )
        machine.screenshot("archi")

        # The welcome screen is drawn by an SWT Browser widget, which dlopens
        # webkitgtk through appendRunpaths.
        machine.wait_until_succeeds(
            'grep -q "libwebkit2gtk" "/proc/$(pgrep -f "equinox[.]launcher_")/maps"'
        )
  '';
}
