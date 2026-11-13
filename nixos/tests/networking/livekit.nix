{
  config,
  lib,
  pkgs,
  ...
}:
{
  name = "livekit";
  meta.maintainers = [ lib.maintainers.quadradical ];

  nodes.machine = {
    services.livekit = {
      enable = true;
      keyFile = pkgs.writers.writeYAML "keys.yaml" {
        key = "f6lQGaHtM5HfgZjIcec3cOCRfiDqIine4CpZZnqdT5cE";
      };
      settings.port = 8000;
    };

    specialisation.ingress = {
      inheritParentConfig = true;
      configuration = {
        services.livekit = {
          ingress.enable = true;
          redis.port = 6379;
        };
      };
    };
  };

  testScript = ''
    with subtest("Test livekit service"):
      machine.wait_for_unit("livekit.service")
      machine.wait_for_open_port(8000)
      machine.succeed("curl 127.0.0.1:8000 -L --fail")

    with subtest("Test locally distributed livekit service with ingress component"):
      machine.succeed("${config.nodes.machine.system.build.toplevel}/specialisation/ingress/bin/switch-to-configuration test")
      machine.wait_for_unit("livekit-ingress.service")
      machine.wait_for_open_port(8080)
      machine.log(machine.succeed("curl --fail -X OPTIONS 127.0.0.1:8080/whip/test"))
  '';
}
