{
  runTest,
}:
let
  tests = {
    wayland =
      { lib, pkgs, ... }:
      {
        imports = [ ./common/wayland-cage.nix ];
        environment.variables = {
          QT_QPA_PLATFORM = "wayland";
          XDG_RUNTIME_DIR = "/run/user/1000"; # Required for wayland platform plug-in
        };
        services.cage.program = "${lib.getExe pkgs.qtcreator}";
      };
    xorg =
      { lib, pkgs, ... }:
      {
        imports = [
          ./common/user-account.nix
          ./common/x11.nix
        ];
        environment.variables.QT_QPA_PLATFORM = "xcb";
        services.xserver.displayManager.sessionCommands = "${lib.getExe pkgs.qtcreator}";
      };
  };

  mkTest =
    name: machine:
    runTest (
      { lib, ... }:
      {
        inherit name;

        nodes."${name}" = machine;

        meta.maintainers = [ lib.maintainers.zatm8 ];

        enableOCR = true;

        testScript = ''
          @polling_condition
          def qtcreator_running():
              machine.succeed('pgrep -x .qtcreator-wrap')

          start_all()

          machine.wait_for_unit('graphical.target')

          qtcreator_running.wait() # type: ignore[union-attr]
          with qtcreator_running: # type: ignore[union-attr]
              machine.wait_for_text('(Projects|Examples|Tutorials|Courses)')
              machine.screenshot('start_screen')
        '';
      }
    );
in
builtins.mapAttrs mkTest tests
