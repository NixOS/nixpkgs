{ lib, pkgs, ... }:
{
  name = "nuclear";

  nodes.machine =
    { lib, pkgs, ... }:
    {
      imports = [ ./common/wayland-cage.nix ];

      services.cage.program = "${lib.getExe pkgs.nuclear}";

      environment.variables = {
        GDK_BACKEND = "x11"; # UI is severely broken on VM's wayland
        # GDK_BACKEND = "wayland";
        # DISPLAY = "do not use";
      };

      # Add fonts so text renders properly for OCR
      fonts.packages = with pkgs; [ dejavu_fonts.minimal ];
    };

  meta.maintainers = with lib.maintainers; [ NotAShelf ];

  enableOCR = true;

  testScript = ''
    @polling_condition
    def nuclear_running():
        # Use `pgrep -f` as process name longer than 15 characters will result in zero matches
        # (e.g., nuclear-music-player)
        machine.succeed('pgrep -f nuclear')

    start_all()

    machine.wait_for_unit('graphical.target')

    nuclear_running.wait()
    with nuclear_running:
        with subtest("Check dashboard"):
            machine.wait_for_text('Welcome to Nuclear')
            machine.screenshot('nuclear_ui_loaded')

        with subtest("Check version"):
            machine.send_key('ctrl-comma')
            machine.wait_for_text('${pkgs.nuclear.version}')
            machine.screenshot('nuclear_version')
  '';
}
