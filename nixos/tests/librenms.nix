import ./make-test-python.nix (
  { pkgs, lib, ... }:

  let
    api_token = "f87f42114e44b63ad1b9e3c3d33d6fbe"; # random md5 hash
    wrong_api_token = "e68ba041fcf1eab923a7a6de3af5f726"; # another random md5 hash
  in
  {
    name = "librenms";
    meta.maintainers = lib.teams.wdz.members;

    nodes.librenms = {
      time.timeZone = "Europe/Berlin";

      environment.systemPackages = with pkgs; [
        curl
        jq
      ];

      services.librenms = {
        enable = true;
        hostname = "librenms";
        database = {
          createLocally = true;
          host = "localhost";
          database = "librenms";
          username = "librenms";
          passwordFile = pkgs.writeText "librenms-db-pass" "librenmsdbpass";
        };
        nginx = {
          default = true;
        };
        enableOneMinutePolling = true;
        settings = {
          enable_billing = true;
        };
      };

      # systemd oneshot to create a dummy admin user and a API token for testing
      systemd.services.lnms-api-init = {
        description = "LibreNMS API init";
        after = [ "librenms-setup.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "root";
          Group = "root";
        };
        script = ''
          API_USER_NAME=api
          API_TOKEN=${api_token} # random md5 hash

          # we don't need to know the password, it just has to exist
          API_USER_PASS=$(${pkgs.pwgen}/bin/pwgen -s 64 1)
          ${pkgs.librenms}/artisan user:add $API_USER_NAME -r admin -p $API_USER_PASS
          API_USER_ID=$(${pkgs.mariadb}/bin/mysql -D librenms -N -B -e "SELECT user_id FROM users WHERE username = '$API_USER_NAME';")

          ${pkgs.mariadb}/bin/mysql -D librenms -e "INSERT INTO api_tokens (user_id, token_hash, description) VALUES ($API_USER_ID, '$API_TOKEN', 'API User')"
        '';
      };
    };

    nodes.snmphost = {
      networking.firewall.allowedUDPPorts = [ 161 ];

      systemd.services.snmpd = {
        description = "snmpd";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "forking";
          User = "root";
          Group = "root";
          ExecStart =
            let
              snmpd-config = pkgs.writeText "snmpd-config" ''
                com2sec readonly default public

                group MyROGroup v2c        readonly
                view all    included  .1                               80
                access MyROGroup ""      any       noauth    exact  all    none   none

                syslocation Testcity, Testcountry
                syscontact Testi mc Test <test@example.com>
              '';
            in
            "${pkgs.net-snmp}/bin/snmpd -c ${snmpd-config} -C";
        };
      };
    };

    testScript = ''
      start_all()

      snmphost.wait_until_succeeds("pgrep snmpd")

      librenms.wait_for_unit("lnms-api-init.service")
      librenms.wait_for_open_port(80)

      # Test that we can authenticate against the API
      librenms.succeed("curl --fail -H 'X-Auth-Token: ${api_token}' http://localhost/api/v0")
      librenms.fail("curl --fail -H 'X-Auth-Token: ${wrong_api_token}' http://localhost/api/v0")

      # add snmphost as a device
      librenms.succeed("curl --fail -X POST -d '{\"hostname\":\"snmphost\",\"version\":\"v2c\",\"community\":\"public\"}' -H 'X-Auth-Token: ${api_token}' http://localhost/api/v0/devices")

      # wait until snmphost gets polled
      librenms.wait_until_succeeds("test $(curl -H 'X-Auth-Token: ${api_token}' http://localhost/api/v0/devices/snmphost | jq -Mr .devices[0].last_polled) != 'null'")
    '';
  }
)
