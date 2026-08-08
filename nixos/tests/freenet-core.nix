{ lib, ... }:

{
  name = "freenet-core";

  meta.maintainers = [ lib.maintainers.LisaScheers ];

  nodes.machine.services.freenet-core = {
    enable = true;
    gateway = {
      enable = true;
      publicAddress = "127.0.0.1";
    };
    extraArgs = [ "--skip-load-from-network" ];
  };

  testScript = ''
    machine.wait_for_unit("freenet-core.service")
    machine.wait_for_open_port(7509)
    machine.succeed("curl --fail http://127.0.0.1:7509/")
    machine.succeed("test $(systemctl show freenet-core.service -P DynamicUser) = yes")
    machine.succeed("test $(systemctl show freenet-core.service -P MemoryDenyWriteExecute) = no")
    machine.succeed("systemctl show freenet-core.service -P RestrictAddressFamilies | grep -w AF_UNIX")
    machine.succeed("test -d /var/lib/freenet-core")
    machine.succeed("test -d /var/cache/freenet-core")
    machine.succeed("journalctl -u freenet-core.service -o cat | grep INFO >/dev/null")
  '';
}
