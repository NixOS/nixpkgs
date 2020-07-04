# Regression test for systemd-timesync having moved the state directory without
# upstream providing a migration path. https://github.com/systemd/systemd/issues/12131

import ./make-test-python.nix (let
  common = { lib, ... }: {
    # override the `false` value from the qemu-vm base profile
    services.timesyncd.enable = lib.mkForce true;
  };
  mkVM = conf: { imports = [ conf common ]; };
in {
  name = "systemd-timesyncd";
  nodes = {
    current = mkVM {};
    pre1909 = mkVM ({lib, ... }: with lib; {
      # create the path that should be migrated by our activation script when
      # upgrading to a newer nixos version
      system.stateVersion = "19.03";
      system.activationScripts.simulate-old-timesync-state-dir = mkBefore ''
        rm -f /var/lib/systemd/timesync
        mkdir -p /var/lib/systemd /var/lib/private/systemd/timesync
        ln -s /var/lib/private/systemd/timesync /var/lib/systemd/timesync
        chown systemd-timesync: /var/lib/private/systemd/timesync
      '';
    });
  };

  testScript = ''
    start_all()
    current.succeed("systemctl status systemd-timesyncd.service")
    # on a new install with a recent systemd there should not be any
    # leftovers from the dynamic user mess
    current.succeed("test -e /var/lib/systemd/timesync")
    current.succeed("test ! -L /var/lib/systemd/timesync")

    # timesyncd should be running on the upgrading system since we fixed the
    # file bits in the activation script
    pre1909.succeed("systemctl status systemd-timesyncd.service")

    # the path should be gone after the migration
    pre1909.succeed("test ! -e /var/lib/private/systemd/timesync")

    # and the new path should no longer be a symlink
    pre1909.succeed("test -e /var/lib/systemd/timesync")
    pre1909.succeed("test ! -L /var/lib/systemd/timesync")

    # after a restart things should still work and not fail in the activation
    # scripts and cause the boot to fail..
    pre1909.shutdown()
    pre1909.start()
    pre1909.succeed("systemctl status systemd-timesyncd.service")
  '';
})
