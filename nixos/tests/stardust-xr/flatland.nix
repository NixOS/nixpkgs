{ ... }:
{
  name = "stardust-xr-flatland";

  nodes.machine =
    {
      lib,
      pkgs,
      config,
      ...
    }:

    {
      imports = [ ../common/openxr.nix ];

      systemd.user.services.stardust-xr-flatland = {
        wantedBy = [ "xdg-desktop-autostart.target" ];
        requires = [ "stardust-xr-server.service" ];
        after = [ "stardust-xr-server.service" ];
        script = lib.getExe pkgs.stardust-xr-flatland;
      };

      systemd.user.services.test-wayland-app = {
        wantedBy = [ "xdg-desktop-autostart.target" ];
        requires = [ "stardust-xr-flatland.service" ];
        after = [ "stardust-xr-flatland.service" ];
        script = "${lib.getExe' pkgs.weston "weston-presentation-shm"} -i";
      };
    };

  testScript =
    { nodes, ... }:
    ''
      with subtest("Ensure X11 starts"):
        start_all()
        machine.succeed("loginctl enable-linger alice")
        machine.wait_for_x()

      with subtest("Ensure system works"):
        machine.wait_for_unit("test-wayland-app.service", "alice")
        # TODO: 10 seconds should be long enough for anything, but this is theoretically flaky
        machine.sleep(10)
        machine.screenshot("screen")
    '';
}
