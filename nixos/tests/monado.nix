{ ... }:
{
  name = "monado";

  nodes.machine =
    {
      lib,
      pkgs,
      config,
      ...
    }:

    {
      imports = [ ./common/openxr.nix ];

      systemd.user.services.print-openxr-info = {
        wantedBy = [ "xdg-desktop-autostart.target" ];
        requires = [ "monado.service" ];
        script = lib.getExe' pkgs.openxr-loader "openxr_runtime_list";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      systemd.user.services.xrgears = {
        wantedBy = [ "xdg-desktop-autostart.target" ];
        requires = [ "monado.service" ];
        script = lib.getExe pkgs.xrgears;
      };
    };

  testScript =
    { nodes, ... }:
    ''
      with subtest("Ensure X11 starts"):
        start_all()
        machine.succeed("loginctl enable-linger alice")
        machine.wait_for_x()

      with subtest("Ensure default runtime present"):
        machine.succeed("stat /etc/xdg/openxr/1/active_runtime.json")

      with subtest("Ensure forced runtime present"):
        # Monado needs to be started to create the forced runtime file
        machine.systemctl("start monado.service", "alice")
        machine.wait_for_unit("monado.service", "alice")
        machine.succeed("stat /home/alice/.config/openxr/1/active_runtime.json")

      with subtest("Ensure openxr_runtime_list can find runtime"):
        machine.wait_for_unit("print-openxr-info.service", "alice")

      with subtest("Ensure xrgears launches"):
        machine.wait_for_unit("xrgears.service", "alice")
        # TODO: 10 seconds should be long enough for anything, but this is theoretically flaky
        machine.sleep(10)
        machine.screenshot("screen")
    '';
}
