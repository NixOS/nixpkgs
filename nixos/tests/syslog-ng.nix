{ lib, ... }:
{
  name = "syslog-ng";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  containers.sender = {
    services.syslog-ng = {
      enable = true;
      extraConfig = ''
        source s_local {
          system();
          internal();
        };
        destination d_receiver {
          network("receiver" transport("udp") port(514));
        };
        log {
          source(s_local);
          destination(d_receiver);
        };
      '';
    };

    systemd.services.hello-logger = {
      environment.MESSAGE = "greetings from hello-logger";
      serviceConfig.Type = "oneshot";
      script = ''
        echo "$MESSAGE"
      '';
    };
  };

  containers.receiver = {
    services.syslog-ng = {
      enable = true;
      extraConfig = ''
        source s_network {
          network(transport("udp") port(514));
        };
        destination d_file {
          file("/var/log/received.log");
        };
        log {
          source(s_network);
          destination(d_file);
        };
      '';
    };

    networking.firewall.allowedUDPPorts = [ 514 ];
  };

  testScript =
    { containers, ... }:
    let
      inherit (containers.sender.systemd.services.hello-logger.environment) MESSAGE;
    in
    ''
      start_all()

      sender.wait_for_unit("syslog-ng.service")
      receiver.wait_for_unit("syslog-ng.service")

      sender.systemctl("start hello-logger.service")
      receiver.wait_until_succeeds("grep -q '${MESSAGE}' /var/log/received.log")
    '';
}
