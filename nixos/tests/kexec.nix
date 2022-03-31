# Test whether fast reboots via kexec work.

import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "kexec";
  meta = with lib.maintainers; {
    maintainers = [ eelco ];
  };

  nodes.machine = { ... }:
    { virtualisation.vlans = [ ]; };

  testScript =
    ''
      machine.wait_for_unit("multi-user.target")
      machine.succeed('kexec --load /run/current-system/kernel --initrd /run/current-system/initrd --command-line "$(</proc/cmdline)"')
      machine.execute("systemctl kexec >&2 &", check_return=False)
      machine.connected = False
      machine.connect()
      machine.wait_for_unit("multi-user.target")
      machine.shutdown()
    '';
})
