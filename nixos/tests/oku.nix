{
  lib,
  pkgs,
  ...
}:
{
  name = "oku";

  meta.maintainers = with lib.maintainers; [ ethancedwards8 ];

  nodes.machine = {
    imports = [ ./common/x11.nix ];

    environment.systemPackages = with pkgs; [ oku ];
  };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    with subtest("Wait until Oku has finished loading the Valgrind docs page"):
      machine.execute("xterm -e 'oku -n file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html' >&2 &");
      machine.wait_for_window("oku")
  '';

}
