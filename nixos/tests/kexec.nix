# Test whether fast reboots via kexec work.

import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "kexec";
  meta = with lib.maintainers; {
    maintainers = [ eelco ];
    # Currently hangs forever; last output is:
    #     machine # [   10.239914] dhcpcd[707]: eth0: adding default route via fe80::2
    #     machine: waiting for the VM to finish booting
    #     machine # Cannot find the ESP partition mount point.
    #     machine # [   28.681197] nscd[692]: 692 checking for monitored file `/etc/netgroup': No such file or directory
    broken = true;
  };

  machine = { ... }:
    { virtualisation.vlans = [ ]; };

  testScript =
    ''
      machine.wait_for_unit("multi-user.target")
      machine.execute("systemctl kexec >&2 &", check_return=False)
      machine.connected = False
      machine.wait_for_unit("multi-user.target")
    '';
})
