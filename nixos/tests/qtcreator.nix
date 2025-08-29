{
  runTest,
  package,
  plugin,
}:
let
  tests = {
    wayland =
      { config, lib, ... }:
      {
        imports = [ ./common/wayland-cage.nix ];
        environment.variables = {
          QT_QPA_PLATFORM = "wayland";
          XDG_RUNTIME_DIR = "/run/user/1000"; # Required for wayland platform plug-in
        };

        programs.qtcreator = {
          enable = true;
          defaultEditor = true;
          package = package;
          plugins = [ plugin ];
        };
      };
    xorg =
      { config, lib, ... }:
      {
        imports = [
          ./common/user-account.nix
          ./common/x11.nix
        ];
        environment.variables.QT_QPA_PLATFORM = "xcb";
        programs.qtcreator = {
          enable = true;
          defaultEditor = true;
          package = package;
          plugins = [ plugin ];
        };
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

          # Package is installed as a system package
          machine.succeed("which qtcreator")

          # The EDITOR environment variable is set
          machine.succeed('test $(basename "$EDITOR") = qtcreator')

          # QtC version matching the package one
          machine.succeed("qtcreator --version | grep 'Qt Creator ${package.version}'")

          # 3rd-party plug-in has been loaded
          machine.succeed("qtcreator --version | grep 'qodeassist ${plugin.version}'")

          # GUI is working properly
          machine.execute("qtcreator >&2 &")

          qtcreator_running.wait() # type: ignore[union-attr]
          with qtcreator_running: # type: ignore[union-attr]
              machine.wait_for_text('(Projects|Examples|Tutorials|Courses)')
              machine.screenshot('start_screen')
        '';
      }
    );
in
builtins.mapAttrs mkTest tests
