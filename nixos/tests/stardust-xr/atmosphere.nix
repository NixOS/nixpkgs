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

      virtualisation.memorySize = 4096;

      systemd.user.services.stardust-xr-atmosphere = {
        wantedBy = [ "xdg-desktop-autostart.target" ];
        requires = [ "stardust-xr-server.service" ];
        after = [ "stardust-xr-server.service" ];
        script = ''
          set -eufx pipefail
          ${lib.getExe pkgs.stardust-xr-atmosphere} install ${pkgs.stardust-xr-atmosphere}/share/atmosphere/default_envs/the_grid
          ${lib.getExe pkgs.stardust-xr-atmosphere} set-default the_grid
          ${lib.getExe pkgs.stardust-xr-atmosphere} show
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
          # TODO(@Pandapip1): 20 seconds should be long enough for anything, but this is theoretically flaky
          # Adding systemd notify support to stardust-xr-atmosphere should resolve this
          machine.sleep(20)
          machine.screenshot("screen")
    '';
}
