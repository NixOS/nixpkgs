# Test that ngx_pagespeed works

import ./make-test.nix ({ pkgs, ...} : {
  name = "nginx-pagespeed";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ dtzWill ];
  };

  nodes = {
    webserver = { config, pkgs, ... }: {
      services.nginx = {
        enable = true;

        virtualHosts = let base = {
            locations."/".root = pkgs.writeTextDir "test.html" ''
              <!DOCTYPE html>
              <html>
              <body>

              Hello world!

              </body>
              </html>
            '';
          }; in {
          server = base // {
            default = true;
            enablePagespeed = true;
          };
          disabled = base;
        };
      };
    };
  };

  testScript = ''
    startAll;

    $webserver->waitForUnit("nginx");
    $webserver->waitForOpenPort("80");

    my $get = "curl -s --fail http://localhost/test.html";

    # Ensure server runs and serves our document
    $webserver->succeed("$get | grep -qF 'Hello world'");

    # Check for Pagespeed header (and log to stderr)
    $webserver->succeed("$get -I | grep -qF 'X-Page-Speed:' 1>&2");

    # Check one of the CoreFilters worked: 'add_head'
    $webserver->succeed("$get | grep -F '<head'");

    # Check that the cache directory was created
    # (it's likely empty but should exist)
    $webserver->succeed("ls -ld /var/cache/ngx_pagespeed 1>&2");


    # Check second vhost does not have pagespeed enabled
    my $get2 = "$get -H 'Host: disabled'";

    # First ensure we can access it
    $webserver->succeed("$get2 | grep -qF 'Hello world'");

    # Now check that pagespeed is off
    $webserver->fail("$get2 -I | grep -qF 'X-Page-Speed:' 1>&2");
    $webserver->fail("$get2 | grep -F '<head'");


    $webserver->shutdown;
  '';
})
