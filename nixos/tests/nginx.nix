# verifies:
#   1. nginx generates config file with shared http context definitions above
#      generated virtual hosts config.
#   2. whether the ETag header is properly generated whenever we're serving
#      files in Nix store paths

import ./make-test.nix ({ pkgs, ... }: {
  name = "nginx";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mbbx6spp ];
  };

  nodes = let
    commonConfig = { pkgs, ... }: {
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
    };
  in {
    webserver = commonConfig;

    newwebserver = { pkgs, lib, ... }: {
      imports = [ commonConfig ];
      services.nginx.virtualHosts.localhost = {
        root = lib.mkForce (pkgs.runCommand "testdir2" {} ''
          mkdir "$out"
          echo hello world > "$out/index.html"
        '');
      };
    };
  };

  testScript = { nodes, ... }: let
    newServerSystem = nodes.newwebserver.config.system.build.toplevel;
    switch = "${newServerSystem}/bin/switch-to-configuration test";
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
      $webserver->succeed('${switch}');
      my $newEtag = checkEtag;
      die "Old ETag $oldEtag is the same as $newEtag" if $oldEtag eq $newEtag;
    };
  '';
})
