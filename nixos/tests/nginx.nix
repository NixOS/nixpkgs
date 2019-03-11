# verifies:
#   1. nginx generates config file with shared http context definitions above
#      generated virtual hosts config.

import ./make-test.nix ({ pkgs, ...} : {
  name = "nginx";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mbbx6spp ];
  };

  nodes = {
    webserver =
      { nodes, ... }:
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
        services.nginx.virtualHosts."0.my.test" = {
          extraConfig = ''
            access_log syslog:server=unix:/dev/log,facility=user,tag=mytag,severity=info ceeformat;
          '';
        };
        services.nginx.exposeConfig = true;

        nesting.clone = [
          ({ ... }: {
            _module.args.nodes = nodes;
            services.nginx.virtualHosts."1.my.test".listen = [ { addr = "127.0.0.1"; port = 8080; }];
          })
          ({ pkgs, ... }: {
            _module.args.nodes = nodes;
            services.nginx.package = pkgs.nginxUnstable;
          })
        ];
      };
  };

  testScript = { nodes, ...}: let
    c1System = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-1";
    c2System = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-2";
  in ''
    startAll;

    $webserver->waitForUnit("nginx");
    $webserver->waitForOpenPort("80");

    $webserver->succeed("${c1System}/bin/switch-to-configuration test >&2");
    $webserver->waitForOpenPort("8080");
    $webserver->fail("journalctl -u nginx | grep -q -i stopped");
    $webserver->succeed("journalctl -u nginx | grep -q -i reloaded");

    $webserver->succeed("${c2System}/bin/switch-to-configuration test >&2");
    $webserver->waitForUnit("nginx");
    $webserver->succeed("journalctl -u nginx | grep -q -i stopped");
  '';
})
