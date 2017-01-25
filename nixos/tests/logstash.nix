# This test runs logstash and checks if messages flows and
# elasticsearch is started.

import ./make-test.nix ({ pkgs, ...} : {
  name = "logstash";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco chaoflow offline ];
  };

  nodes = {
    one =
      { config, pkgs, ... }:
        {
          services = {
            logstash = {
              enable = true;
              inputConfig = ''
                exec { command => "echo flowers" interval => 1 type => "test" }
                exec { command => "echo dragons" interval => 1 type => "test" }
              '';
              filterConfig = ''
                if [message] =~ /dragons/ {
                  drop {}
                }
              '';
              outputConfig = ''
                stdout { codec => rubydebug }
              '';
            };
          };
        };
    };

  testScript = ''
    startAll;

    $one->waitForUnit("logstash.service");
    $one->waitUntilSucceeds("journalctl -n 20 _SYSTEMD_UNIT=logstash.service | grep flowers");
    $one->fail("journalctl -n 20 _SYSTEMD_UNIT=logstash.service | grep dragons");
  '';
})
