{ lib, ... }:

{
  name = "libvirt-dbus";
  meta.maintainers = with lib.maintainers; [ andre4ik3 ];

  nodes.machine = {
    virtualisation.libvirtd = {
      enable = true;
      dbus.enable = true;
    };
  };

  testScript = ''
    # Wait for the machine to start up
    machine.wait_for_unit("multi-user.target")

    # The service is activated on-demand and shouldn't be active yet
    machine.fail("systemctl is-active libvirt-dbus.service")

    # Get the hostname property of the Test connection (this will activate the service)
    machine.succeed("busctl get-property org.libvirt /org/libvirt/Test org.libvirt.Connect Hostname")

    # Now the service should be active
    machine.succeed("systemctl is-active libvirt-dbus.service")
  '';
}
