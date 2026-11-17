{ lib, ... }:
{
  name = "systemd-varlink";
  meta.maintainers = [ lib.maintainers.raitobezarius ];
  nodes.machine =
    { config, pkgs, ... }:
    {
      networking.useNetworkd = true;
      services.resolved.enable = true;
      systemd.network.enable = true;
    };
  testScript = ''
    def list_interfaces(intf_path: str) -> list[str]:
      return machine.succeed(f"varlinkctl list-interfaces {intf_path}").split('\n')

    expected_reg_sd_interfaces = [
      ("BootControl", "bootctl"),
      ("Credentials", "creds"),
      ("Hostname", "hostnamed"),
      ("JournalAccess", "journald"),
      ("Import", "importd"),
      ("Machine", "machined"),
      ("Resolve", "resolved-varlink"),
      ("Resolve.Monitor", "resolved-monitor"),
      ("Udev", "udevd-varlink"),
      ("MuteConsole", "mute-console"),
      ("FactoryReset", "factory-reset"),
      ("AskPassword", "ask-password"),
      ("Network", "networkd-varlink"),
      ("Repart", "repart"),
    ]
    expected_priv_sd_interfaces = [
      ("Login", None), # systemd-logind-varlink.socket exist but is not necessary.
    ]
    expected_interfaces = [
      (f"io.systemd.{intf}", f"systemd-{socket_name}", f"/run/varlink/registry/io.systemd.{intf}") for intf, socket_name in expected_reg_sd_interfaces
    ] + [
      (f"io.systemd.{intf}", f"systemd-{socket_name}" if socket_name is not None else None, f"/run/systemd/io.systemd.{intf}") for intf, socket_name in expected_priv_sd_interfaces
    ]

    for intf, socket_name, intf_path in expected_interfaces:
      if socket_name is not None:
        machine.wait_for_unit(f"{socket_name}.socket")
      assert intf in list_interfaces(intf_path), f"Interface '{intf}' not found in the Varlink registry"
  '';
}
