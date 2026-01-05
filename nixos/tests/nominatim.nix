{ pkgs, lib, ... }:

let
  # Andorra - the smallest dataset in Europe (3.1 MB)
  osmData = pkgs.fetchurl {
    url = "https://web.archive.org/web/20250430211212/https://download.geofabrik.de/europe/andorra-latest.osm.pbf";
    hash = "sha256-Ey+ipTOFUm80rxBteirPW5N4KxmUsg/pCE58E/2rcyE=";
  };
in
{
  name = "nominatim";
  meta = {
    maintainers = with lib.teams; geospatial.members ++ ngi.members;
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
        system.activationScripts = {
          passwordFile.text = with config.services.nominatim.database; ''
            mkdir -p /run/secrets
            echo "${host}:${toString port}:${dbname}:${apiUser}:password" \
              > /run/secrets/pgpass
            chown nominatim-api:nominatim-api /run/secrets/pgpass
            chmod 0600 /run/secrets/pgpass
          '';
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
  };

  testScript = ''
    # Test nominatim host
    nominatim.start()
    nominatim.wait_for_unit("nominatim.service")

    # Import OSM data
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
  '';
}
