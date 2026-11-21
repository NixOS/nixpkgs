{ pkgs, lib, ... }:
{
  name = "freecad";

  meta = {
    maintainers = with lib.maintainers; [ tmarkus ];
  };

  nodes.machine = {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    test-support.displayManager.auto.user = "alice";

    environment.systemPackages = [ pkgs.freecad ];

    fonts.packages = [ pkgs.dejavu_fonts ];
  };

  enableOCR = true;

  testScript =
    { ... }:
    let
      runFreecad = args: ''machine.succeed("su - alice -c 'FreeCAD ${args}' >&2");'';
      runFreecadBg = args: ''machine.succeed("su - alice -c 'FreeCAD ${args}' >&2 &");'';
    in
    ''
      machine.start()
      machine.wait_for_x()

      # there are more available tests, we run just a subset to reduce test runtime
      ${runFreecad "--run-test BaseTests"}
      ${runFreecad "--run-test MeshTestsApp"}
      ${runFreecad "--run-test TestPartDesignApp"}
      ${runFreecad "--run-test TestPartDesignGui"}

      ${runFreecadBg (lib.escapeShellArg "${pkgs.freecad}/share/examples/PartDesignExample.FCStd")}
      machine.wait_for_text("Welcome to FreeCAD")
      machine.screenshot("freecad_part_design_example")
      machine.succeed("pkill FreeCAD")
    '';
}
