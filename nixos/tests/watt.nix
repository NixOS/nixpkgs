{ pkgs, lib, ... }:
{
  name = "watt";
  meta.maintainers = with lib.maintainers; [ Soliprem ];

  nodes.machine = _: {
    services.watt.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("watt.service")
    machine.succeed("watt --version | grep ${pkgs.watt.version}")
    machine.wait_until_succeeds("busctl --system status net.hadess.PowerProfiles")
    machine.wait_until_succeeds("busctl --system status dev.notashelf.Watt")
    machine.succeed("busctl --system introspect net.hadess.PowerProfiles /net/hadess/PowerProfiles net.hadess.PowerProfiles")
    machine.succeed("busctl --system introspect dev.notashelf.Watt /dev/notashelf/Watt dev.notashelf.Watt")
    machine.succeed("busctl --system get-property dev.notashelf.Watt /dev/notashelf/Watt dev.notashelf.Watt Version | grep ${pkgs.watt.version}")
  '';
}
