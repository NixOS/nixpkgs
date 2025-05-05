{
  lib,
  pkgs,
  ...
}:
{
  name = "send";

  meta = {
    maintainers = with lib.maintainers; [
      moraxyc
      MrSom3body
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        curl
        ffsend
      ];

      services.send = {
        enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("send.service")

    machine.wait_for_open_port(1443)

    machine.succeed("curl --fail --max-time 10 http://127.0.0.1:1443")

    machine.succeed("echo HelloWorld > /tmp/test")
    url = machine.succeed("ffsend upload -q -h http://127.0.0.1:1443/ /tmp/test")
    machine.succeed(f'ffsend download --output /tmp/download {url}')
    machine.succeed("cat /tmp/download | grep HelloWorld")
  '';
}
