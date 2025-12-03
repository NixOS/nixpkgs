{
  lib,
  pkgs,
  ...
}:
{
  name = "servo";

  meta.maintainers = with lib.maintainers; [ hexa ];

  nodes.machine = {
    imports = [ ./common/x11.nix ];

    environment.systemPackages = with pkgs; [ servo ];
  };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    with subtest("Wait until Servo has finished loading the Valgrind docs page"):
      machine.execute("xterm -e 'servo file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html' >&2 &");
      machine.wait_for_window("Valgrind")
      machine.wait_for_text("Quick Start Guide")
  '';

}
