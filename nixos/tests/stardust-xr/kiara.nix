{ ... }:
{
  name = "stardust-xr-kiara";

  # Doesn't understand @polling_condition
  skipTypeCheck = true;

  nodes.machine =
    {
      lib,
      pkgs,
      config,
      ...
    }:

    {
      imports = [ ./common.nix ];

      systemd.user.services.stardust-xr-kiara = {
        wantedBy = [ "xdg-desktop-autostart.target" ];
        requires = [ "stardust-xr-server.service" ];
        after = [ "stardust-xr-server.service" ];
        script = lib.getExe pkgs.stardust-xr-kiara;
        environment.RUST_BACKTRACE = "full";
      };

      systemd.user.services.test-wayland-app = {
        wantedBy = [ "xdg-desktop-autostart.target" ];
        requires = [ "stardust-xr-kiara.service" ];
        after = [ "stardust-xr-kiara.service" ];
        script = "${lib.getExe' pkgs.weston "weston-presentation-shm"} -i";
      };
    };

  testScript =
    { nodes, ... }:
    ''
      @polling_condition()
      def wayland_client_running():
        machine.wait_for_unit("stardust-xr-atmosphere.service", "alice")

      with subtest("Ensure X11 starts"):
        start_all()
        machine.succeed("loginctl enable-linger alice")
        machine.wait_for_x()

      with subtest("Ensure system works"):
        with wayland_client_running:
          # TODO: 10 seconds should be long enough for anything, but this is theoretically flaky
          machine.sleep(10)
          machine.screenshot("screen")
    '';
}
