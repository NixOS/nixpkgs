{ pkgs, ... }:
{
  name = "lightdm-sway";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ magic_rb ];
  };

  nodes.machine =
    { ... }:
    {
      imports = [ ./common/user-account.nix ];
      services.xserver.enable = true;
      services.xserver.displayManager.lightdm.enable = true;
      services.xserver.displayManager.extraSystemdAwareSessions = [ "sway-uwsm" ];
      services.displayManager.defaultSession = "sway-uwsm";
      environment.variables = {
        "WLR_RENDERER" = "pixman";
        "SWAYSOCK" = "/tmp/sway-ipc.sock";
      };

      # Need to switch to a different GPU driver than the default one (-vga std) so that Sway can launch:
      virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];

      programs.sway.enable = true;

      programs.uwsm = {
        enable = true;

        waylandCompositors.sway = {
          prettyName = "sway";
          comment = "Sway";
          binPath = pkgs.lib.getExe' pkgs.sway "sway";
        };
      };
    };

  enableOCR = true;

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.config.users.users.alice;
      uid = toString user.uid;

      run = command: "su - ${user.name} -c 'WAYLAND_DISPLAY=wayland-0 ${command}'";
    in
    ''
      start_all()
      machine.wait_for_text("${user.description}")
      machine.screenshot("lightdm")
      machine.send_chars("${user.password}\n")
      machine.wait_for_file("/run/user/${uid}/wayland-1")
      machine.succeed("${run "swaymsg -t get_version"}")
    '';
}
