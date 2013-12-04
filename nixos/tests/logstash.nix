{ pkgs, ... }:

# This test runs logstash and checks if messages flows and elasticsearch is
# started

{
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
                if [type] == "test" {
                  grep { match => ["message", "flowers"] drop => true }
                }
              '';
              outputConfig = ''
                stdout { codec => rubydebug }
                elasticsearch { embedded => true }
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
    $one->waitUntilSucceeds("curl -s http://127.0.0.1:9200/_status?pretty=true | grep logstash");
  '';
}
