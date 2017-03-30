# verifies:
#   1. nginx generates config file with shared http context definitions above
#      generated virtual hosts config.
#   2. configuration reload works and nginx keeps running with old confi on
#      syntax errors

import ./make-test.nix ({ pkgs, ...} : {
  name = "nginx";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mbbx6spp fpletz ];
  };

  nodes = let
    commonConfig = customCfg:
      { lib, ... }:
      lib.mkMerge [
        { services.nginx.enable = true;
          services.nginx.commonHttpConfig = ''
          log_format ceeformat '@cee: {"status":"$status",'
            '"request_time":$request_time,'
            '"upstream_response_time":$upstream_response_time,'
            '"pipe":"$pipe","bytes_sent":$bytes_sent,'
            '"connection":"$connection",'
            '"remote_addr":"$remote_addr",'
            '"host":"$host",'
            '"timestamp":"$time_iso8601",'
            '"request":"$request",'
            '"http_referer":"$http_referer",'
            '"upstream_addr":"$upstream_addr"}';
          '';
          services.nginx.virtualHosts."_".extraConfig = ''
            access_log syslog:server=unix:/dev/log,facility=user,tag=mytag,severity=info ceeformat;
          '';
        }
        customCfg
      ];
    in {
      webserver = commonConfig {
        services.nginx.virtualHosts."_".extraConfig = "return 200 works;";
      };
      webserver_new = commonConfig {
        services.nginx.virtualHosts."_".extraConfig = "return 200 new-content;";
        services.nginx.package = pkgs.nginxMainline;
      };
      webserver_invalid = commonConfig {
        services.nginx.appendHttpConfig = "foo";
      };
    };

  testScript = { nodes, ... }: let
      webserver_new = nodes.webserver_new.config.system.build.toplevel;
      webserver_invalid = nodes.webserver_invalid.config.system.build.toplevel;
    in ''
    $webserver->start;

    $webserver->waitForUnit("nginx");
    $webserver->waitForOpenPort("80");
    $webserver->succeed("[[ `curl http://localhost/` == \"works\" ]]");

    $webserver->succeed("${webserver_new}/bin/switch-to-configuration test");

    $webserver->waitForUnit("nginx");
    $webserver->waitForOpenPort("80");
    $webserver->succeed("[[ `curl http://localhost/` == \"new-content\" ]]");

    $webserver->fail("${webserver_invalid}/bin/switch-to-configuration test");

    $webserver->waitForUnit("nginx");
    $webserver->waitForOpenPort("80");
    $webserver->succeed("[[ `curl http://localhost/` == \"new-content\" ]]");
  '';
})
