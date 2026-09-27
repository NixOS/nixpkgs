{ pkgs, ... }:
{
  name = "corosync-qnetd";

  meta.maintainers = with pkgs.lib.maintainers; [ hddq ];

  nodes.machine = {
    services.corosync-qnetd.enable = true;
    services.corosync-qnetd.openFirewall = true;
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("corosync-qnetd.service")
    machine.wait_for_open_port(5403)
    machine.succeed("corosync-qnetd-tool -s")
  '';
}
