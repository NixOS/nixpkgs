{ ... }:
{
  name = "stardust-xr-atmosphere";

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

      systemd.user.services.stardust-xr-atmosphere = {
        wantedBy = [ "xdg-desktop-autostart.target" ];
        requires = [ "stardust-xr-server.service" ];
        after = [ "stardust-xr-server.service" ];
        script = ''
          ${lib.getExe pkgs.stardust-xr-atmosphere} install ${pkgs.srcOnly pkgs.stardust-xr-atmosphere}/default_envs/the_grid
          ${lib.getExe pkgs.stardust-xr-atmosphere} show the_grid
        '';
        environment.RUST_BACKTRACE = "full";
      };
    };

  testScript =
    { nodes, ... }:
    ''
      @polling_condition()
      def atmosphere_running():
        machine.wait_for_unit("stardust-xr-atmosphere.service", "alice")

      with subtest("Ensure X11 starts"):
        start_all()
        machine.succeed("loginctl enable-linger alice")
        machine.wait_for_x()

      with subtest("Ensure system works"):
        with atmosphere_running:
          # TODO: 10 seconds should be long enough for anything, but this is theoretically flaky
          machine.sleep(10)
          machine.screenshot("screen")
    '';
}
