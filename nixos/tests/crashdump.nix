{ pkgs, ... }:
{
  name = "crashdump";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ Scrumplex ];
  };

  nodes.machine =
    { ... }:
    {
      boot.initrd.systemd.enable = true;
      boot.kernel.sysctl."kernel.sysrq" = 1;
      boot.crashDump = {
        enable = true;
        automatic = true;
      };
    };

  testScript = ''
    machine.start(allow_reboot=True)

    machine.wait_for_unit("load-crashkernel.service")
    machine.execute("echo c > /proc/sysrq-trigger", check_output=False, check_return=False)
    machine.connected = False # We need to reconnect after the panic

    machine.succeed("grep 'Kernel panic - not syncing: sysrq triggered crash' /dmesg.txt")
  '';
}
