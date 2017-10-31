import ./make-test.nix ({ pkgs, ...} :

let

  # Build Quake with coverage instrumentation.
  overrides = pkgs:
    rec {
      quake3game = pkgs.quake3game.override (args: {
        stdenv = pkgs.stdenvAdapters.addCoverageInstrumentation args.stdenv;
      });
    };

  # Only allow the demo data to be used (only if it's unfreeRedistributable).
  unfreePredicate = pkg: with pkgs.lib; let
    allowDrvPredicates = [ "quake3-demo" "quake3-pointrelease" ];
    allowLicenses = [ pkgs.lib.licenses.unfreeRedistributable ];
  in any (flip hasPrefix pkg.name) allowDrvPredicates &&
     elem (pkg.meta.license or null) allowLicenses;

in

rec {
  name = "quake3";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ domenkozar eelco chaoflow ];
  };

  # TODO: lcov doesn't work atm
  #makeCoverageReport = true;

  client =
    { config, pkgs, ... }:

    { imports = [ ./common/x11.nix ];
      hardware.opengl.driSupport = true;
      environment.systemPackages = [ pkgs.quake3demo ];
      nixpkgs.config.packageOverrides = overrides;
      nixpkgs.config.allowUnfreePredicate = unfreePredicate;
    };

  nodes =
    { server =
        { config, pkgs, ... }:

        { systemd.services."quake3-server" =
            { wantedBy = [ "multi-user.target" ];
              script =
                "${pkgs.quake3demo}/bin/quake3-server +set g_gametype 0 " +
                "+map q3dm7 +addbot grunt +addbot daemia 2> /tmp/log";
            };
          nixpkgs.config.packageOverrides = overrides;
          nixpkgs.config.allowUnfreePredicate = unfreePredicate;
          networking.firewall.allowedUDPPorts = [ 27960 ];
        };

      client1 = client;
      client2 = client;
    };

  testScript =
    ''
      startAll;

      $server->waitForUnit("quake3-server");
      $client1->waitForX;
      $client2->waitForX;

      $client1->execute("quake3 +set r_fullscreen 0 +set name Foo +connect server &");
      $client2->execute("quake3 +set r_fullscreen 0 +set name Bar +connect server &");

      $server->waitUntilSucceeds("grep -q 'Foo.*entered the game' /tmp/log");
      $server->waitUntilSucceeds("grep -q 'Bar.*entered the game' /tmp/log");

      $server->sleep(10); # wait for a while to get a nice screenshot

      $client1->block();

      $server->sleep(20);

      $client1->screenshot("screen1");
      $client2->screenshot("screen2");

      $client1->unblock();

      $server->sleep(10);

      $client1->screenshot("screen3");
      $client2->screenshot("screen4");

      $client1->shutdown();
      $client2->shutdown();
      $server->stopJob("quake3-server");
    '';

})
