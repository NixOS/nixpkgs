import ./make-test-python.nix (
  { lib, pkgs, ... }:

  let
    config_refresh = "10";
    nullvalue = "NULL";
    utc = false;
  in
  {
    name = "osquery";
    meta.maintainers = with lib.maintainers; [
      znewman01
      lewo
    ];

    nodes.machine =
      { config, pkgs, ... }:
      {
        services.osquery = {
          enable = true;

          settings.options = { inherit nullvalue utc; };
          flags = {
            inherit config_refresh;
            nullvalue = "IGNORED";
          };
        };
      };

    testScript =
      { nodes, ... }:
      let
        cfg = nodes.machine.services.osquery;
      in
      ''
        machine.start()
        machine.wait_for_unit("osqueryd.service")

        # Stop the osqueryd service so that we can use osqueryi to check information stored in the database.
        machine.wait_until_succeeds("systemctl stop osqueryd.service")

        # osqueryd was able to query information about the host.
        machine.succeed("echo 'SELECT address FROM etc_hosts LIMIT 1;' | osqueryi | tee /dev/console | grep -q '127.0.0.1'")

        # osquery binaries respect configuration from the Nix config option.
        machine.succeed("echo 'SELECT value FROM osquery_flags WHERE name = \"utc\";' | osqueryi | tee /dev/console | grep -q ${lib.boolToString utc}")

        # osquery binaries respect configuration from the Nix flags option.
        machine.succeed("echo 'SELECT value FROM osquery_flags WHERE name = \"config_refresh\";' | osqueryi | tee /dev/console | grep -q ${config_refresh}")

        # Demonstrate that osquery binaries prefer configuration plugin options over CLI flags.
        # https://osquery.readthedocs.io/en/latest/deployment/configuration/#options.
        machine.succeed("echo 'SELECT value FROM osquery_flags WHERE name = \"nullvalue\";' | osqueryi | tee /dev/console | grep -q ${nullvalue}")

        # Module creates directories for default database_path and pidfile flag values.
        machine.succeed("test -d $(dirname ${cfg.flags.database_path})")
        machine.succeed("test -d $(dirname ${cfg.flags.pidfile})")
      '';
  }
)
