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
    machine.succeed("test -d /var/lib/freenet-core")
    machine.succeed("test -d /var/log/freenet-core")
  '';
}
