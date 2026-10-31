{ ... }:

{
  name = "obs-studio";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [
        ./common/x11.nix
        ./common/user-account.nix
      ];

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vkcapture
        ];
        enableVirtualCamera = true;
      };
    };

  testScript = ''
    machine.wait_for_x()
    machine.succeed("obs --version")

    # virtual camera tests
    machine.succeed("lsmod | grep v4l2loopback")
    machine.succeed("ls /dev/video1")
    machine.succeed("obs --startvirtualcam >&2 &")
    machine.wait_for_window("OBS")
    machine.sleep(5)

    # test plugins
    machine.succeed("which obs-vkcapture")
  '';
}
