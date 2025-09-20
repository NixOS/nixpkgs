{ lib, pkgs, ... }:
{
  name = "qodeassist-plugin";

  meta.maintainers = [ lib.maintainers.zatm8 ];

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];
      environment.variables.QT_QPA_PLATFORM = "offscreen";

      programs.qtcreator = {
        enable = true;
        defaultEditor = true;
        plugins = [ pkgs.qt6Packages.qodeassist-plugin ];
      };
    };

  testScript = ''
    # Package is installed as a system package
    machine.succeed("which qtcreator")

    # QodeAssist plug-in has been loaded
    machine.succeed("qtcreator --version | grep 'qodeassist ${pkgs.qt6Packages.qodeassist-plugin.version}'")
  '';
}
