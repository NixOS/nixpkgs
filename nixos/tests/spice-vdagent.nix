import ./make-test-python.nix ({ lib, pkgs, ... }:
{
  name = "spice-vdagent";
  meta.maintainers = with lib.maintainers; [ dmytrokyrychuk ];

  nodes = {
    machine =
      { pkgs, ... }:
      {
        imports = [
          ./common/user-account.nix
        ];


        services.xserver.enable = true;
        services.xserver.displayManager.sddm.enable = true;
        services.xserver.desktopManager.plasma5.enable = true;
        services.xserver.displayManager.autoLogin = {
          enable = true;
          user = "alice";
        };

        services.spice-vdagentd.enable = true;
        services.spice-vdagent.enable = true;
      };
  };

  testScript = { nodes }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      machine.wait_for_unit("spice-vdagentd")

      # Expecting the service to fail on startup because the test VM is missing
      # the required virtio channel.
      machine.wait_until_succeeds("su -c journalctl ${user.name} | grep 'vdagent virtio channel /dev/virtio-ports/com.redhat.spice.0 does not exist, exiting'")
    '';
})
