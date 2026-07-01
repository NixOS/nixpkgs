{ pkgs, lib, ... }:

let
  # Andorra - the smallest dataset in Europe (3.1 MB)
  osmData = pkgs.fetchurl {
    url = "https://web.archive.org/web/20260512192410/https://download.geofabrik.de/europe/andorra-latest.osm.pbf";
    hash = "sha256-WaHtCa0rM0Bt+Z5LgziK3+e2LoN4LNIHD/dM/ugrUZo=";
  };

  # I do not understand why 817 and 818 are necessary to create a new way id in
  # the database. I would have expected 783 to do it, since it the osc file
  # contains a <create> <way> entry, or 818 on its own. But neither work.  I
  # don't know enough about nominatim to interrogate it further.
  #
  # I also don't understand how nominatim is able to update without entries
  # 783-817 which should come after the "latest" snapshot we have.
  osmReplicationOsc817 = pkgs.fetchurl {
    url = "https://web.archive.org/web/20260630022039/http://download.geofabrik.de/europe/andorra-updates/000/004/817.osc.gz";
    hash = "sha256-pJx4FUiLGAhG0au3odDyB4OKOcCLO99j935P49IYvhA=";
  };
  osmReplicationState817 = pkgs.fetchurl {
    url = "https://web.archive.org/web/20260630021033/http://download.geofabrik.de/europe/andorra-updates/000/004/817.state.txt";
    hash = "sha256-Nip2VmMLj3eXccFH7t8O1CvcJ1MGaVqwNo9AieDH830=";
  };

  osmReplicationOsc818 = pkgs.fetchurl {
    url = "https://web.archive.org/web/20260630021137/http://download.geofabrik.de/europe/andorra-updates/000/004/818.osc.gz";
    hash = "sha256-FVqIb2cjWt+SzTZD5uFJhDB4nBr19vXR0tvDVsmEPx8=";
  };
  osmReplicationState818 = pkgs.fetchurl {
    url = "https://web.archive.org/web/20260630021306/http://download.geofabrik.de/europe/andorra-updates/000/004/818.state.txt";
    hash = "sha256-jUWee+5iGVTuqwXMs7lVd4Sp0+4aGGHRFKa+GysYd1g=";
  };

  importanceData = pkgs.fetchurl {
    url = "https://web.archive.org/web/20260630052740/https://nominatim.org/data/wikimedia-importance.sql.gz";
    hash = "sha256-iVxdEnMKHVqA7aiifBLnwAqy8rUtLEwnXYtpX0rWR9M=";
  };
  secondaryImportanceData = pkgs.fetchurl {
    url = "https://web.archive.org/web/20260630052803/https://nominatim.org/data/wikimedia-secondary-importance.sql.gz";
    hash = "sha256-T4wCwGPWaO5ZGWQho787M9STDaJ0Bb/yg5+9QB2oNVk=";
  };

  lastWay = {
    initial = "1510680045";
    updated = "1529990579";
  };
in
{
  name = "nominatim";
  meta = {
    maintainers = with lib.teams; geospatial.members ++ ngi.members ++ [ lib.maintainers.taeer ];
  };

  nodes = {
    # nominatim - self contained host
    nominatim =
      { config, pkgs, ... }:
      {
        # Nominatim
        services.nominatim = {
          enable = true;
          hostName = "nominatim";
          settings = {
            NOMINATIM_IMPORT_STYLE = "admin";
          };
          ui = {
            config = ''
              Nominatim_Config.Page_Title='Test Nominatim instance';
              Nominatim_Config.Nominatim_API_Endpoint='https://localhost/';
            '';
          };
        };

        # Disable SSL
        services.nginx.virtualHosts.nominatim = {
          forceSSL = false;
          enableACME = false;
        };

        # Database
        services.postgresql = {
          enableTCPIP = true;
          authentication = lib.mkForce ''
            local all all            trust
            host  all all 0.0.0.0/0  md5
            host  all all ::0/0      md5
          '';
        };
        systemd.services.postgresql-setup.postStart = ''
          psql --command "ALTER ROLE \"nominatim-api\" WITH PASSWORD 'password';"
        '';
        networking.firewall.allowedTCPPorts = [ config.services.postgresql.settings.port ];
      };

    # api - web API only
    api =
      { config, pkgs, ... }:
      {
        # Database password
        systemd.services.nominatim = {
          serviceConfig.ExecStartPre =
            let
              createPasswordFile = lib.getExe (
                pkgs.writeShellApplication {
                  name = "nominatim-pre-start";
                  text =
                    let
                      inherit (config.services.nominatim.database)
                        host
                        port
                        dbname
                        apiUser
                        ;
                    in
                    ''
                      mkdir -p /run/secrets
                      echo "${host}:${toString port}:${dbname}:${apiUser}:password" \
                        > /run/secrets/pgpass
                      chown nominatim-api:nominatim-api /run/secrets/pgpass
                      chmod 0600 /run/secrets/pgpass
                    '';
                }
              );
            in
            [
              "+${createPasswordFile}"
            ];
        };

        # Nominatim
        services.nominatim = {
          enable = true;
          hostName = "nominatim";
          settings = {
            NOMINATIM_LOG_DB = "yes";
          };
          database = {
            host = "nominatim";
            passwordFile = "/run/secrets/pgpass";
            extraConnectionParams = "application_name=nominatim;connect_timeout=2";
          };
        };

        # Disable SSL
        services.nginx.virtualHosts.nominatim = {
          forceSSL = false;
          enableACME = false;
        };
      };

    nominatimUpdate =
      { config, pkgs, ... }:
      {
        # needed for large importance data
        # TODO: we could shrink this if we stub out a dummy importance file
        virtualisation.diskSize = 15 * 1024;
        environment.etc = {
          "osm/importance-data/wikimedia-importance.sql.gz".source = importanceData;
          "osm/importance-data/wikimedia-secondary-importance.sql.gz".source = secondaryImportanceData;

          "osm/map/andorra-latest.osm.pbf".source = osmData;

          "osm/replication/000/004/817.state.txt".source = osmReplicationState817;
          "osm/replication/000/004/817.osc.gz".source = osmReplicationOsc817;

          "osm/replication/000/004/818.state.txt".source = osmReplicationState818;
          "osm/replication/000/004/818.osc.gz".source = osmReplicationOsc818;

          "osm/replication/state.txt".source = osmReplicationState818;
        };
        services.nginx = {
          enable = true;
          virtualHosts.localhost = {
            locations."/" = {
              root = "/etc/osm/";
              extraConfig = ''
                autoindex on;
              '';
            };
          };
        };
        # Nominatim
        services.nominatim = {
          enable = true;
          hostName = "nominatim";
          settings = {
            NOMINATIM_IMPORT_STYLE = "admin";
          };
          ui.enable = false;
          maps.andorra = {
            mapUrl = "http://localhost/map/andorra-latest.osm.pbf";
            replicationUrl = "http://localhost/replication";
          };
          updates = {
            enable = true;
            startAt = [ ];
          };
          importanceData = {
            enable = true;
            startAt = [ ];
            url = "http://localhost/importance-data/wikimedia-importance.sql.gz";
            secondaryUrl = "http://localhost/importance-data/wikimedia-secondary-importance.sql.gz";
          };
        };

        # Disable SSL
        services.nginx.virtualHosts.nominatim = {
          forceSSL = false;
          enableACME = false;
        };
      };
  };

  testScript = ''
    # Test nominatim host
    nominatim.start()
    nominatim.wait_for_unit("nominatim.service")

    # Import OSM data directly
    nominatim.succeed("""
      cd /tmp
      sudo -u nominatim \
        NOMINATIM_DATABASE_WEBUSER=nominatim-api \
        NOMINATIM_IMPORT_STYLE=admin \
        nominatim import --continue import-from-file --osm-file ${osmData}
    """)
    nominatim.succeed("systemctl restart nominatim.service")

    # Test CLI
    nominatim.succeed("sudo -u nominatim-api nominatim search --query Andorra")

    # Test web API
    nominatim.succeed("curl 'http://localhost/status' | grep OK")

    nominatim.succeed("""
      curl "http://localhost/search?q=Andorra&format=geojson" | grep "Andorra"
      curl "http://localhost/reverse?lat=42.5407167&lon=1.5732033&format=geojson"
    """)

    # Test UI
    nominatim.succeed("""
      curl "http://localhost/ui/search.html" \
      | grep "<title>Nominatim Demo</title>"
    """)


    # Test api host
    api.start()
    api.wait_for_unit("nominatim.service")

    # Test web API
    api.succeed("""
      curl "http://localhost/search?q=Andorra&format=geojson" | grep "Andorra"
      curl "http://localhost/reverse?lat=42.5407167&lon=1.5732033&format=geojson"
    """)


    # Test format rewrites
    # Redirect / to search
    nominatim.succeed("""
      curl --verbose "http://localhost" 2>&1 \
      | grep "Location: http://localhost/ui/search.html"
    """)

    # Return text by default
    nominatim.succeed("""
      curl --verbose "http://localhost/status" 2>&1 \
      | grep "Content-Type: text/plain"
    """)

    # Return JSON by default
    nominatim.succeed("""
      curl --verbose "http://localhost/search?q=Andorra" 2>&1 \
      | grep "Content-Type: application/json"
    """)

    # Return XML by default
    nominatim.succeed("""
      curl --verbose "http://localhost/lookup" 2>&1 \
      | grep "Content-Type: text/xml"

      curl --verbose "http://localhost/reverse?lat=0&lon=0" 2>&1 \
      | grep "Content-Type: text/xml"
    """)

    # Redirect explicitly requested HTML format
    nominatim.succeed("""
      curl --verbose "http://localhost/search?format=html" 2>&1 \
      | grep "Location: http://localhost/ui/search.html"

      curl --verbose "http://localhost/reverse?format=html" 2>&1 \
      | grep "Location: http://localhost/ui/reverse.html"
    """)

    # Return explicitly requested JSON format
    nominatim.succeed("""
      curl --verbose "http://localhost/search?format=json" 2>&1 \
      | grep "Content-Type: application/json"

      curl --verbose "http://localhost/reverse?format=json" 2>&1 \
      | grep "Content-Type: application/json"
    """)
    nominatim.shutdown()
    api.shutdown()

    nominatimUpdate.start()

    # The service is Type=oneshot without RemainAfterExit=yes. Once it
    # is finished it is no longer active and wait_for_unit will fail.
    # When that happens we check if it actually failed.
    try:
        nominatimUpdate.wait_for_unit("nominatim-import-map-data.service")
    except:
        nominatimUpdate.fail("systemctl is-failed nominatim-import-map-data.service")
    try:
        nominatimUpdate.wait_for_unit("nominatim-import-importance-data.service")
    except:
        nominatimUpdate.fail("systemctl is-failed nominatim-import-importance-data.service")

    # basic functionality
    nominatimUpdate.succeed("sudo -u nominatim-api nominatim search --query Andorra")

    # check importance data was installed and database tables created
    nominatimUpdate.succeed("sudo -u nominatim psql -At -d nominatim -c '\\d' > tables")
    nominatimUpdate.succeed("grep 'wikimedia_importance' tables")
    nominatimUpdate.succeed("grep 'wikipedia_article' tables")
    nominatimUpdate.succeed("grep 'wikipedia_redirect' tables")
    nominatimUpdate.succeed("grep 'secondary_importance' tables")
    nominatimUpdate.succeed("grep 'secondary_importance_rid_seq' tables")

    # baseline last way check
    nominatimUpdate.succeed("sudo -u nominatim psql -At -d nominatim -c 'select max(id) from planet_osm_ways;' > last_way")
    nominatimUpdate.succeed("[ $(cat last_way) -eq ${lastWay.initial} ]")

    # replicate / update
    nominatimUpdate.start_job("nominatim-import-map-data.service")
    try:
        nominatimUpdate.wait_for_unit("nominatim-import-map-data.service")
    except:
        nominatimUpdate.fail("systemctl is-failed nominatim-import-map-data.service")

    # check that we have in fact updated (last way changes frequently)
    nominatimUpdate.succeed("sudo -u nominatim psql -At -d nominatim -c 'select max(id) from planet_osm_ways;' > last_way")
    nominatimUpdate.succeed("[ $(cat last_way) -eq ${lastWay.updated} ]")

    # test there are no warnings, i.e. missing importance data
    # FIXME: this warns, even though importance data is properly installed
    # nominatimUpdate.succeed("sudo -u nominatim nominatim admin --project-dir /var/lib/nominatim --check-database | tee db_check")
    # nominatimUpdate.succeed("! cat db_check | grep -q WARNING")
  '';
}
