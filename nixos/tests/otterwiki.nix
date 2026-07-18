{ lib, ... }:
{
  name = "otterwiki";

  meta = {
    maintainers = with lib.maintainers; [ euxane ];
  };

  nodes.machine =
    { config, ... }:
    {
      services.otterwiki.instances."test" = {
        settings = {
          SITE_NAME = "My test wiki";
          READ_ACCESS = "ANONYMOUS";
        };

        socket = {
          inherit (config.services.nginx) user group;
        };
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts."localhost".locations."/" = {
          proxyPass = "http://unix:${config.services.otterwiki.instances."test".socket.address}";
        };
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl -sSf localhost | grep -q 'Your Otter Wiki is up and running.'")
    machine.shutdown()
  '';
}
