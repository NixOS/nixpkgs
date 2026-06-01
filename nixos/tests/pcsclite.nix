{
  lib,
  ...
}:

{
  name = "pcsclite";
  meta.maintainers = [ lib.maintainers.bjornfor ];

  nodes = {
    machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.pcsc-tools
        ];
        services.pcscd = {
          enable = true;
        };
      };
  };

  testScript = ''
    machine.wait_for_unit("pcscd.socket")

    with subtest("client can connect"):
        machine.succeed("pcsc_scan -r")
  '';
}
