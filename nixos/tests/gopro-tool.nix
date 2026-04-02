{ lib, pkgs, ... }:

let
  testScript = ''
    start_all()

    machine.wait_for_unit("multi-user.target")

    # Check that gopro-tool is installed
    machine.succeed("which gopro-tool")

    # Check that the v4l2loopback module is available
    machine.succeed("lsmod | grep v4l2loopback || echo 'Module not found'")

    # Check that VLC is installed
    machine.succeed("which vlc")
  '';
in
{
  name = "gopro-tool";
  meta.maintainers = with lib.maintainers; [ ZMon3y ];
  nodes.machine =
    { config, pkgs, ... }:
    {
      # Ensure dependencies are installed
      environment.systemPackages = with pkgs; [
        gopro-tool
        vlc
      ];

      # Load kernel module for testing
      boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

      # Enable module loading
      boot.kernelModules = [ "v4l2loopback" ];
    };

  testScript = testScript;
}
