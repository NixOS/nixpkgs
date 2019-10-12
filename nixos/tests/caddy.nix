import ./make-test.nix ({ pkgs, ... }: {
  name = "caddy";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ xfix ];
  };

  nodes = {
    webserver = { pkgs, lib, ... }: {
      services.caddy.enable = true;
      services.caddy.config = ''
        http://localhost {
          gzip

          root ${
            pkgs.runCommand "testdir" {} ''
              mkdir "$out"
              echo hello world > "$out/example.html"
            ''
          }
        }
      '';

      nesting.clone = [
        {
          services.caddy.config = lib.mkForce ''
            http://localhost {
              gzip

              root ${
                pkgs.runCommand "testdir2" {} ''
                  mkdir "$out"
                  echo changed > "$out/example.html"
                ''
              }
            }
          '';
        }

        {
          services.caddy.config = ''
            http://localhost:8080 {
            }
          '';
        }
      ];
    };
  };

  testScript = { nodes, ... }: let
    etagSystem = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-1";
    justReloadSystem = "${nodes.webserver.config.system.build.toplevel}/fine-tune/child-2";
  in ''
    my $url = 'http://localhost/example.html';
    $webserver->waitForUnit("caddy");
    $webserver->waitForOpenPort("80");

    sub checkEtag {
      my $etag = $webserver->succeed(
        'curl -v '.$url.' 2>&1 | sed -n -e "s/^< [Ee][Tt][Aa][Gg]: *//p"'
      );
      $etag =~ s/\r?\n$//;
      my $httpCode = $webserver->succeed(
        'curl -w "%{http_code}" -X HEAD -H \'If-None-Match: '.$etag.'\' '.$url
      );
      die "HTTP code is not 304" unless $httpCode == 304;
      return $etag;
    }

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
    };
  '';
})
