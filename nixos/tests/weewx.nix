{ pkgs, ... }:
let
  testConfig = pkgs.writeText "weewx-test.conf" ''
    # Minimal WeeWX test configuration using Simulator driver
    WEEWX_ROOT = /var/lib/weewx
    socket_timeout = 20
    debug = 1

    [Station]
        location = "NixOS Test Weather Station"
        latitude = 61.32
        longitude = -149.32
        altitude = 29, meter
        station_type = Simulator
        station_url = $STATION_SECRET_URL
        rain_year_start = 1
        week_start = 6

    [Simulator]
        driver = weewx.drivers.simulator
        mode = simulator
        start = 2026-10-31T20:00
        loop_interval = 1

    [StdArchive]
        archive_interval = 5
        record_generation = software
        loop_hilo = True
        data_binding = wx_binding

    [DataBindings]
        [[wx_binding]]
            database = archive_sqlite
            table_name = archive
            manager = weewx.manager.DaySummaryManager
            schema = schemas.wview.schema

    [Databases]
        [[archive_sqlite]]
            database_name = weewx.sdb
            database_type = SQLite

    [DatabaseTypes]
        [[SQLite]]
            driver = weedb.sqlite
            SQLITE_ROOT = %(WEEWX_ROOT)s/archive

    [StdReport]
        SKIN_ROOT = skins
        HTML_ROOT = /var/lib/weewx/public_html
        data_binding = wx_binding

        [[SeasonsReport]]
            skin = Seasons
            enable = true

    [Engine]
        [[Services]]
            prep_services = weewx.engine.StdTimeSynch
            data_services = ,
            process_services = weewx.engine.StdConvert, weewx.engine.StdCalibrate, weewx.engine.StdQC, weewx.wxservices.StdWXCalculate
            xtype_services = weewx.wxxtypes.StdWXXTypes, weewx.wxxtypes.StdPressureCooker, weewx.wxxtypes.StdRainRater, weewx.wxxtypes.StdDelta
            archive_services = weewx.engine.StdArchive
            restful_services = ,
            report_services = weewx.engine.StdPrint, weewx.engine.StdReport
  '';
in
{
  name = "weewx";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ xela-zone ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.weewx = {
        enable = true;
        configFile = testConfig;
        extraPythonPackages = ps: [ ps.paho-mqtt ];
        environmentFile = pkgs.writeText "weewx-secrets.env" ''
          STATION_SECRET_URL="https://nixos.org"
        '';
        skins = {
          custom-test = pkgs.writeTextDir "skin.conf" ''
            [CheetahGenerator]
                encoding = html_entities
          '';
        };
      };
    };

  testScript = ''
    machine.start()

    with subtest("Udev rules installed for weather station hardware"):
        machine.succeed("test -e /etc/udev/rules.d/60-weewx.rules")

    with subtest("WeeWX service starts and enters running state"):
        machine.wait_for_unit("weewx.service")

    with subtest("Process isolation and secret protection"):
        # Daemon must run as 'weewx', not root
        machine.succeed("pgrep -u weewx weewxd")

        # Secret file must be protected in 0700 runtime directory with 0600 file mode
        machine.succeed("test $(stat -c '%a' /run/weewx) = '700'")
        machine.succeed("test $(stat -c '%a' /run/weewx/weewx.conf) = '600'")
        machine.fail("su -s /bin/sh nobody -c 'cat /run/weewx/weewx.conf'")

    with subtest("Extra Python packages available to WeeWX"):
        # Verify weectl binary is available on PATH and paho-mqtt was injected into runtime wrapper
        machine.succeed("weectl --help")
        machine.succeed("grep -q 'paho-mqtt' $(dirname $(realpath $(which weectl)))/.weectl-wrapped")

    with subtest("Secrets substitution via environmentFile"):
        # Verify secrets were substituted into /run/weewx/weewx.conf
        machine.succeed("grep 'station_url = https://nixos.org' /run/weewx/weewx.conf")

    with subtest("WeeWX creates archive database and writes records"):
        # Wait for the sqlite database to be created
        machine.wait_for_file("/var/lib/weewx/archive/weewx.sdb")

        # Verify database integrity using weectl
        machine.succeed("weectl database check --config=/run/weewx/weewx.conf")

    with subtest("WeeWX generates HTML report and assets"):
        # Wait for the Seasons skin report to be rendered
        machine.wait_for_file("/var/lib/weewx/public_html/index.html")
        machine.wait_for_file("/var/lib/weewx/public_html/seasons.css")
        machine.succeed("grep -q 'NixOS Test Weather Station' /var/lib/weewx/public_html/index.html")

    with subtest("Built-in and custom skins symlinked into /var/lib/weewx/skins"):
        # Built-in Seasons skin
        machine.succeed("test -L /var/lib/weewx/skins/Seasons")
        machine.succeed("test -f /var/lib/weewx/skins/Seasons/skin.conf")
        # Custom configured skin
        machine.succeed("test -L /var/lib/weewx/skins/custom-test")
        machine.succeed("test -f /var/lib/weewx/skins/custom-test/skin.conf")
  '';
}
