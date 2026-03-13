{ lib, ... }:

{
  name = "voxinput";

  meta.maintainers = [ lib.maintainers.richiejp ];

  nodes.machine =
    { config, ... }:
    {
      imports = [ ./common/user-account.nix ];

      services.voxinput.enable = true;
      services.voxinput.environment = {
        VOXINPUT_PROMPT = "test_prompt";
      };

      services.xserver.enable = true;
      services.xserver.displayManager.lightdm.enable = true;
      services.xserver.desktopManager.xfce.enable = true;
      services.displayManager.autoLogin = {
        enable = true;
        user = "alice";
      };
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus";
    in
    ''
      machine.wait_for_x()
      machine.wait_for_file("${user.home}/.Xauthority")
      machine.wait_until_succeeds("su - ${user.name} -c '${bus} systemctl --user is-active --quiet voxinput.service'")
      env = machine.succeed("su - ${user.name} -c '${bus} systemctl --user show voxinput.service -p Environment'")
      t.assertIn("VOXINPUT_PROMPT=test_prompt", env)
      output = machine.wait_until_succeeds("su - ${user.name} -c 'XDG_RUNTIME_DIR=/run/user/${toString user.uid} ${bus} voxinput status'")
      t.assertIn("idle", output)
    '';
}
