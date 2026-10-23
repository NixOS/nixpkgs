{
  pkgs,
  lib,
  ...
}:
{
  name = "nyxt";

  meta.maintainers = with lib.maintainers; [ ethancedwards8 ];

  nodes.machine = {
    imports = [
      # sets up x11 with autologin
      ./common/x11.nix
    ];

    environment.systemPackages = with pkgs; [ nyxt ];

    # not enough memory for the allocation
    virtualisation.memorySize = 2048;
  };

  enableOCR = true;

  testScript =
    { nodes, ... }:
    ''
      start_all()
      machine.wait_for_x()

      with subtest("Wait until Nyxt has finished loading the Valgrind docs page"):
        machine.execute("xterm -e 'nyxt file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html' >&2 &");
        machine.wait_for_window("nyxt")
    '';
}
