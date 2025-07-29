{ lib, ... }:
let
  # Build Quake with coverage instrumentation.
  overrides = pkgs: {
    quake3game = pkgs.quake3game.override (args: {
      stdenv = pkgs.stdenvAdapters.addCoverageInstrumentation args.stdenv;
    });
  };

  # Only allow the demo data to be used (only if it's unfreeRedistributable).
  unfreePredicate =
    pkg:
    let
      allowPackageNames = [
        "quake3-demodata"
        "quake3-pointrelease"
      ];
      allowLicenses = [ lib.licenses.unfreeRedistributable ];
    in
    lib.elem pkg.pname allowPackageNames && lib.elem (pkg.meta.license or null) allowLicenses;

  client =
    { pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];
      hardware.graphics.enable = true;
      environment.systemPackages = [ pkgs.quake3demo ];
      nixpkgs.config.packageOverrides = overrides;
      nixpkgs.config.allowUnfreePredicate = unfreePredicate;
    };
in
{
  name = "quake3";
  meta.maintainers = with lib.maintainers; [ ];

  node.pkgsReadOnly = false;

  # TODO: lcov doesn't work atm
  #makeCoverageReport = true;

  nodes = {
    server =
      { pkgs, ... }:
      {
        systemd.services.quake3-server = {
          wantedBy = [ "multi-user.target" ];
          script =
            "${pkgs.quake3demo}/bin/quake3-server +set g_gametype 0 "
            + "+map q3dm7 +addbot grunt +addbot daemia 2> /tmp/log";
        };
        nixpkgs.config.packageOverrides = overrides;
        nixpkgs.config.allowUnfreePredicate = unfreePredicate;
        networking.firewall.allowedUDPPorts = [ 27960 ];
      };

    client1 = client;
    client2 = client;
  };

  testScript = ''
    start_all()

    server.wait_for_unit("quake3-server")
    client1.wait_for_x()
    client2.wait_for_x()

    client1.execute("quake3 +set r_fullscreen 0 +set name Foo +connect server >&2 &", check_return = False)
    client2.execute("quake3 +set r_fullscreen 0 +set name Bar +connect server >&2 &", check_return = False)

    server.wait_until_succeeds("grep -q 'Foo.*entered the game' /tmp/log")
    server.wait_until_succeeds("grep -q 'Bar.*entered the game' /tmp/log")

    server.sleep(10)  # wait for a while to get a nice screenshot

    client1.block()

    server.sleep(20)

    client1.screenshot("screen1")
    client2.screenshot("screen2")

    client1.unblock()

    server.sleep(10)

    client1.screenshot("screen3")
    client2.screenshot("screen4")

    client1.shutdown()
    client2.shutdown()
    server.stop_job("quake3-server")
  '';
}
