import ../make-test-python.nix (
  { lib, pkgs, ... }:
  let
    oldNetbox = pkgs.netbox_3_6;
    newNetbox = pkgs.netbox_3_7;
  in
  {
    name = "netbox-upgrade";

    meta = with lib.maintainers; {
      maintainers = [
        minijackson
        raitobezarius
      ];
    };

    nodes.machine =
      { config, ... }:
      {
        virtualisation.memorySize = 2048;
        services.netbox = {
          enable = true;
          package = oldNetbox;
          secretKeyFile = pkgs.writeText "secret" ''
            abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
          '';
        };

        services.nginx = {
          enable = true;

          recommendedProxySettings = true;

          virtualHosts.netbox = {
            default = true;
            locations."/".proxyPass = "http://localhost:${toString config.services.netbox.port}";
            locations."/static/".alias = "/var/lib/netbox/static/";
          };
        };

        users.users.nginx.extraGroups = [ "netbox" ];

        networking.firewall.allowedTCPPorts = [ 80 ];

        specialisation.upgrade.configuration.services.netbox.package = lib.mkForce newNetbox;
      };

    testScript =
      { nodes, ... }:
      let
        apiVersion =
          version:
          lib.pipe version [
            (lib.splitString ".")
            (lib.take 2)
            (lib.concatStringsSep ".")
          ];
        oldApiVersion = apiVersion oldNetbox.version;
        newApiVersion = apiVersion newNetbox.version;
      in
      ''
        start_all()
        machine.wait_for_unit("netbox.target")
        machine.wait_for_unit("nginx.service")
        machine.wait_until_succeeds("journalctl --since -1m --unit netbox --grep Listening")

        def api_version(headers):
            header = [header for header in headers.splitlines() if header.startswith("API-Version:")][0]
            return header.split()[1]

        def check_api_version(version):
            headers = machine.succeed(
              "curl -sSfL http://localhost/api/ --head -H 'Content-Type: application/json'"
            )
            assert api_version(headers) == version

        with subtest("NetBox version is the old one"):
            check_api_version("${oldApiVersion}")

        # Somehow, even though netbox-housekeeping.service has After=netbox.service,
        # netbox-housekeeping.service and netbox.service still get started at the
        # same time, making netbox-housekeeping fail (can't really do some house
        # keeping job if the database is not correctly formed).
        #
        # So we don't check that the upgrade went well, we just check that
        # netbox.service is active, and that netbox-housekeeping can be run
        # successfully afterwards.
        #
        # This is not good UX, but the system should be working nonetheless.
        machine.execute("${nodes.machine.system.build.toplevel}/specialisation/upgrade/bin/switch-to-configuration test >&2")

        machine.wait_for_unit("netbox.service")
        machine.succeed("systemctl start netbox-housekeeping.service")

        with subtest("NetBox version is the new one"):
            check_api_version("${newApiVersion}")
      '';
  }
)
