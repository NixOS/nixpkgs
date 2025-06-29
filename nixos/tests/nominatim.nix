{ pkgs, lib, ... }:

let
  # OpenStreetMap data used in test (Andorra is the smallest dataset in Europe
  # - 3.1 MB).
  osmData = pkgs.fetchurl {
    url = "https://web.archive.org/web/20250430211212/https://download.geofabrik.de/europe/andorra-latest.osm.pbf";
    hash = "sha256-Ey+ipTOFUm80rxBteirPW5N4KxmUsg/pCE58E/2rcyE=";
  };
in
{
  name = "nominatim";
  meta = {
    maintainers = with lib.teams; [ geospatial ngi ];
  };

  interactive.sshBackdoor.enable = true; # FIXME: remove

  nodes = {
    # Self contained host:
    #   * Nominatim database
    #   * Nominatim web API
    nominatim =
      { config, pkgs, ... }:
      {

        # FIXME: remove this block
        virtualisation.forwardPorts = [
          # SSH
          {
            from = "host";
            host.port = 10022;
            guest.port = builtins.elemAt config.services.openssh.ports 0;
          }
        ];

        # Enable Nominatim
        services.nominatim = {
          enable = true;
          hostName = "nominatim";
          settings = {
            NOMINATIM_IMPORT_STYLE = "admin";
          };
        };

        services.nginx.virtualHosts.nominatim = {
          forceSSL = false;
          enableACME = false;
        };

        # Allow remote DB connection for api host
        services.postgresql = {
          enableTCPIP = true;
          authentication = lib.mkForce ''
            local all all            trust
            host  all all 0.0.0.0/0  md5
            host  all all ::0/0      md5
          '';
        };
        networking.firewall.allowedTCPPorts = [ 5432 ];
      };

    # Nominatim web API only host.
    api =
      { config, pkgs, ... }:
      {

        # FIXME: remove this block
        virtualisation.forwardPorts = [
          # SSH
          {
            from = "host";
            host.port = 10023;
            guest.port = builtins.elemAt config.services.openssh.ports 0;
          }
        ];

        system.activationScripts = {
          passwordFile.text = ''
            mkdir -p /run/secrets
            echo "nominatim:5432:nominatim:nominatim-api:password" > /run/secrets/pgpass
            chown nominatim-api:nominatim-api /run/secrets/pgpass
            chmod 0600 /run/secrets/pgpass
          '';
        };

        services.nominatim = {
          enable = true;
          hostName = "nominatim";
          settings = {
            NOMINATIM_LOG_DB = "yes";
          };
          ui.enable = true;
          database = {
            host = "nominatim";
            passwordFile = "/run/secrets/pgpass";
            extraConnectionParams = "application_name=nominatim;connect_timeout=2";
          };
        };

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
    # /nix/store/lr8sdss16g7pvs85yanyj178icsmifqr-andorra-latest.osm.pbf  FIXME: remove line
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


    # Test api host
    # Set DB password to allow connection for api host
    nominatim.succeed("""
      sudo -u postgres \
        psql --command "ALTER ROLE \\"nominatim-api\\" WITH PASSWORD 'password';"
    """)

    api.start()
    api.wait_for_unit("nominatim.service")

    # Test web API
    api.succeed("""
      curl "http://localhost/search?q=Andorra&format=geojson" | grep "Andorra"
      curl "http://localhost/reverse?lat=42.5407167&lon=1.5732033&format=geojson"
    """)

    # TODO: test data update
  '';
}
