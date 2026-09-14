{
  lib,
  pkgs,
  config,
  ...
}:
let
  # Build Quake with coverage instrumentation.
  overrides = pkgs: {
    quake3game = pkgs.quake3game.override (args: {
      stdenv = pkgs.stdenvAdapters.addCoverageInstrumentation args.stdenv;
    });
  };

  client =
    {
      playerName,
      ...
    }:
    {
      config,
      ...
    }:
    {
      imports = [ ./common/wayland-cage.nix ];
      hardware.graphics.enable = true;
      services.cage.program = "${lib.getExe config.programs.ioquake3.finalPackage} +connect server";

      programs.ioquake3 = {
        enable = true;
        settings = {
          r_fullscreen = 0;
          name = playerName;
        };
      };
      # nixpkgs.config.packageOverrides = overrides;
    };
in
{
  name = "quake3";
  meta.maintainers = [ lib.maintainers.onny ];

  # TODO: lcov doesn't work atm
  #makeCoverageReport = true;

  nodes = {
    server =
      { ... }:
      {
        services.quake3-server = {
          enable = true;
          openFirewall = true;
          settings.g_gametype = 0;
          extraConfig = ''
            map q3dm7
            addbot grunt
            addbot daemia
          '';
        };
        # nixpkgs.config.packageOverrides = overrides;
      };

    client1 = client { playerName = "Foo"; };
    client2 = client { playerName = "Bar"; };
  };

  testScript = { nodes, ... }: ''
    start_all()

    # server.wait_for_unit("q3ds")
    client1.wait_for_unit("graphical.target")
    client2.wait_for_unit("graphical.target")

    server.wait_until_succeeds(
        "journalctl -u q3ds.service | grep -q 'Foo.*entered the game'"
    )
    server.wait_until_succeeds(
        "journalctl -u q3ds.service | grep -q 'Bar.*entered the game'"
    )

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
