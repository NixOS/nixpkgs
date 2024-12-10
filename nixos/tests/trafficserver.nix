# verifies:
#   1. Traffic Server is able to start
#   2. Traffic Server spawns traffic_crashlog upon startup
#   3. Traffic Server proxies HTTP requests according to URL remapping rules
#      in 'services.trafficserver.remap'
#   4. Traffic Server applies per-map settings specified with the conf_remap
#      plugin
#   5. Traffic Server caches HTTP responses
#   6. Traffic Server processes HTTP PUSH requests
#   7. Traffic Server can load the healthchecks plugin
#   8. Traffic Server logs HTTP traffic as configured
#
# uses:
#   - bin/traffic_manager
#   - bin/traffic_server
#   - bin/traffic_crashlog
#   - bin/traffic_cache_tool
#   - bin/traffic_ctl
#   - bin/traffic_logcat
#   - bin/traffic_logstats
#   - bin/tspush
import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "trafficserver";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ midchildan ];
    };

    nodes = {
      ats =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        let
          user = config.users.users.trafficserver.name;
          group = config.users.groups.trafficserver.name;
          healthchecks = pkgs.writeText "healthchecks.conf" ''
            /status /tmp/ats.status text/plain 200 500
          '';
        in
        {
          services.trafficserver.enable = true;

          services.trafficserver.records = {
            proxy.config.http.server_ports = "80 80:ipv6";
            proxy.config.hostdb.host_file.path = "/etc/hosts";
            proxy.config.log.max_space_mb_headroom = 0;
            proxy.config.http.push_method_enabled = 1;

            # check that cache storage is usable before accepting traffic
            proxy.config.http.wait_for_cache = 2;
          };

          services.trafficserver.plugins = [
            {
              path = "healthchecks.so";
              arg = toString healthchecks;
            }
            { path = "xdebug.so"; }
          ];

          services.trafficserver.remap = ''
            map http://httpbin.test http://httpbin
            map http://pristine-host-hdr.test http://httpbin \
              @plugin=conf_remap.so \
              @pparam=proxy.config.url_remap.pristine_host_hdr=1
            map http://ats/tspush http://httpbin/cache \
              @plugin=conf_remap.so \
              @pparam=proxy.config.http.cache.required_headers=0
          '';

          services.trafficserver.storage = ''
            /dev/vdb volume=1
          '';

          networking.firewall.allowedTCPPorts = [ 80 ];
          virtualisation.emptyDiskImages = [ 256 ];
          services.udev.extraRules = ''
            KERNEL=="vdb", OWNER="${user}", GROUP="${group}"
          '';
        };

      httpbin =
        { pkgs, lib, ... }:
        let
          python = pkgs.python3.withPackages (
            ps: with ps; [
              httpbin
              gunicorn
              gevent
            ]
          );
        in
        {
          systemd.services.httpbin = {
            enable = true;
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = "${python}/bin/gunicorn -b 0.0.0.0:80 httpbin:app -k gevent";
            };
          };

          networking.firewall.allowedTCPPorts = [ 80 ];
        };

      client =
        { pkgs, lib, ... }:
        {
          environment.systemPackages = with pkgs; [ curl ];
        };
    };

    testScript =
      { nodes, ... }:
      let
        sampleFile = pkgs.writeText "sample.txt" ''
          It's the season of White Album.
        '';
      in
      ''
        import json
        import re

        ats.wait_for_unit("trafficserver")
        ats.wait_for_open_port(80)
        httpbin.wait_for_unit("httpbin")
        httpbin.wait_for_open_port(80)
        client.systemctl("start network-online.target")
        client.wait_for_unit("network-online.target")

        with subtest("Traffic Server is running"):
            out = ats.succeed("traffic_ctl server status")
            assert out.strip() == "Proxy -- on"

        with subtest("traffic_crashlog is running"):
            ats.succeed("pgrep -f traffic_crashlog")

        with subtest("basic remapping works"):
            out = client.succeed("curl -vv -H 'Host: httpbin.test' http://ats/headers")
            assert json.loads(out)["headers"]["Host"] == "httpbin"

        with subtest("conf_remap plugin works"):
            out = client.succeed(
                "curl -vv -H 'Host: pristine-host-hdr.test' http://ats/headers"
            )
            assert json.loads(out)["headers"]["Host"] == "pristine-host-hdr.test"

        with subtest("caching works"):
            out = client.succeed(
                "curl -vv -D - -H 'Host: httpbin.test' -H 'X-Debug: X-Cache' http://ats/cache/60 -o /dev/null"
            )
            assert "X-Cache: miss" in out

            out = client.succeed(
                "curl -vv -D - -H 'Host: httpbin.test' -H 'X-Debug: X-Cache' http://ats/cache/60 -o /dev/null"
            )
            assert "X-Cache: hit-fresh" in out

        with subtest("pushing to cache works"):
            url = "http://ats/tspush"

            ats.succeed(f"echo {url} > /tmp/urls.txt")
            out = ats.succeed(
                f"tspush -f '${sampleFile}' -u {url}"
            )
            assert "HTTP/1.0 201 Created" in out, "cache push failed"

            out = ats.succeed(
                "traffic_cache_tool --spans /etc/trafficserver/storage.config find --input /tmp/urls.txt"
            )
            assert "Span: /dev/vdb" in out, "cache not stored on disk"

            out = client.succeed(f"curl {url}").strip()
            expected = (
                open("${sampleFile}").read().strip()
            )
            assert out == expected, "cache content mismatch"

        with subtest("healthcheck plugin works"):
            out = client.succeed("curl -vv http://ats/status -o /dev/null -w '%{http_code}'")
            assert out.strip() == "500"

            ats.succeed("touch /tmp/ats.status")

            out = client.succeed("curl -vv http://ats/status -o /dev/null -w '%{http_code}'")
            assert out.strip() == "200"

        with subtest("logging works"):
            access_log_path = "/var/log/trafficserver/squid.blog"
            ats.wait_for_file(access_log_path)

            out = ats.succeed(f"traffic_logcat {access_log_path}").split("\n")[0]
            expected = "^\S+ \S+ \S+ TCP_MISS/200 \S+ GET http://httpbin/headers - DIRECT/httpbin application/json$"
            assert re.fullmatch(expected, out) is not None, "no matching logs"

            out = json.loads(ats.succeed(f"traffic_logstats -jf {access_log_path}"))
            assert isinstance(out, dict)
            assert out["total"]["error.total"]["req"] == "0", "unexpected log stat"
      '';
  }
)
