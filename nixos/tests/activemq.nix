{ lib, ... }:

{
  name = "activemq";
  meta.maintainers = [ lib.maintainers.anthonyroussel ];

  nodes.machine =
    { pkgs, config, ... }:
    {
      services.activemq = {
        enable = true;
        package = pkgs.activemq;
        extraJavaOptions = [
          "-Djava.security.auth.login.config=${config.services.activemq.configurationDir}/login.config"
        ];
      };
    };

  testScript = ''
    machine.wait_for_unit("activemq.service")

    with subtest("Check if ports are open"):
      machine.wait_for_open_port(8161) # http api
      machine.wait_for_open_port(1883) # mqtt
      machine.wait_for_open_port(5672) # amqp
      machine.wait_for_open_port(61613) # stomp
      machine.wait_for_open_port(61616) # openwire

    with subtest("Check web console"):
      machine.succeed("curl -sS --fail -u admin:admin http://127.0.0.1:8161/admin/")
  '';
}
