# verifies:
#   1. nginx generates config file with shared http context definitions above
#      generated virtual hosts config.
#   2. whether the ETag header is properly generated whenever we're serving
#      files in Nix store paths
#   3. nginx doesn't restart on configuration changes (only reloads)
import ./make-test.nix ({ pkgs, ... }: {
  name = "nginx";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mbbx6spp ];
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
      ];
    };

  };

  testScript = { nodes, ... }: let
    etagSystem = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-1";
    justReloadSystem = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-2";
    reloadRestartSystem = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-3";
  in ''
    my $url = 'http://localhost/index.html';

    sub checkEtag {
      my $etag = $webserver->succeed(
        'curl -v '.$url.' 2>&1 | sed -n -e "s/^< [Ee][Tt][Aa][Gg]: *//p"'
      );
      $etag =~ s/\r?\n$//;
      my $httpCode = $webserver->succeed(
        'curl -w "%{http_code}" -X HEAD -H \'If-None-Match: '.$etag.'\' '.$url
      );
      chomp $httpCode;
      die "HTTP code is not 304" unless $httpCode == 304;
      return $etag;
    }

    $webserver->waitForUnit("nginx");
    $webserver->waitForOpenPort("80");

    subtest "check ETag if serving Nix store paths", sub {
      my $oldEtag = checkEtag;
      $webserver->succeed("${etagSystem}/bin/switch-to-configuration test >&2");
      $webserver->sleep(1); # race condition
      my $newEtag = checkEtag;
      die "Old ETag $oldEtag is the same as $newEtag" if $oldEtag eq $newEtag;
    };

    subtest "config is reloaded on nixos-rebuild switch", sub {
      $webserver->succeed("${justReloadSystem}/bin/switch-to-configuration test >&2");
      $webserver->waitForOpenPort("8080");
      $webserver->fail("journalctl -u nginx | grep -q -i stopped");
      $webserver->succeed("journalctl -u nginx | grep -q -i reloaded");
    };

    subtest "restart when nginx package changes", sub {
      $webserver->succeed("${reloadRestartSystem}/bin/switch-to-configuration test >&2");
      $webserver->waitForUnit("nginx");
      $webserver->succeed("journalctl -u nginx | grep -q -i stopped");
    };
  '';
})
