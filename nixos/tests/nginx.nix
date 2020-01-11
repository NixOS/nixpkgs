# verifies:
#   1. nginx generates config file with shared http context definitions above
#      generated virtual hosts config.
#   2. whether the ETag header is properly generated whenever we're serving
#      files in Nix store paths
#   3. nginx doesn't restart on configuration changes (only reloads)
import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nginx";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mbbx6spp danbst ];
  };

  nodes = {
    webserver = { pkgs, lib, ... }: {
      services.nginx.enable = true;
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
          location /favicon.ico { allow all; access_log off; log_not_found off; }
        '';
      };

      services.nginx.virtualHosts.localhost = {
        root = pkgs.runCommand "testdir" {} ''
          mkdir "$out"
          echo hello world > "$out/index.html"
        '';
      };

      services.nginx.enableReload = true;

      nesting.clone = [
        {
          services.nginx.virtualHosts.localhost = {
            root = lib.mkForce (pkgs.runCommand "testdir2" {} ''
              mkdir "$out"
              echo content changed > "$out/index.html"
            '');
          };
        }

        {
          services.nginx.virtualHosts."1.my.test".listen = [ { addr = "127.0.0.1"; port = 8080; }];
        }

        {
          services.nginx.package = pkgs.nginxUnstable;
        }

        {
          services.nginx.package = pkgs.nginxUnstable;
          services.nginx.virtualHosts."!@$$(#*%".locations."~@#*$*!)".proxyPass = ";;;";
        }
      ];
    };

  };

  testScript = { nodes, ... }: let
    etagSystem = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-1";
    justReloadSystem = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-2";
    reloadRestartSystem = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-3";
    reloadWithErrorsSystem = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-4";
  in ''
    url = "http://localhost/index.html"


    def check_etag():
        etag = webserver.succeed(
            f'curl -v {url} 2>&1 | sed -n -e "s/^< etag: *//ip"'
        ).rstrip()
        http_code = webserver.succeed(
            f"curl -w '%{{http_code}}' --head --fail -H 'If-None-Match: {etag}' {url}"
        )
        assert http_code.split("\n")[-1] == "304"

        return etag


    webserver.wait_for_unit("nginx")
    webserver.wait_for_open_port(80)

    with subtest("check ETag if serving Nix store paths"):
        old_etag = check_etag()
        webserver.succeed(
            "${etagSystem}/bin/switch-to-configuration test >&2"
        )
        webserver.sleep(1)
        new_etag = check_etag()
        assert old_etag != new_etag

    with subtest("config is reloaded on nixos-rebuild switch"):
        webserver.succeed(
            "${justReloadSystem}/bin/switch-to-configuration test >&2"
        )
        webserver.wait_for_open_port(8080)
        webserver.fail("journalctl -u nginx | grep -q -i stopped")
        webserver.succeed("journalctl -u nginx | grep -q -i reloaded")

    with subtest("restart when nginx package changes"):
        webserver.succeed(
            "${reloadRestartSystem}/bin/switch-to-configuration test >&2"
        )
        webserver.wait_for_unit("nginx")
        webserver.succeed("journalctl -u nginx | grep -q -i stopped")

    with subtest("nixos-rebuild --switch should fail when there are configuration errors"):
        webserver.fail(
            "${reloadWithErrorsSystem}/bin/switch-to-configuration test >&2"
        )
        webserver.succeed("[[ $(systemctl is-failed nginx-config-reload) == failed ]]")
        webserver.succeed("[[ $(systemctl is-failed nginx) == active ]]")
        # just to make sure operation is idempotent. During development I had a situation
        # when first time it shows error, but stops showing it on subsequent rebuilds
        webserver.fail(
            "${reloadWithErrorsSystem}/bin/switch-to-configuration test >&2"
        )
  '';
})
