{
  name,
  pkgs,
  testBase,
  system,
  ...
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest (
  { config, ... }:
  let
    inherit (config) adminuser;
  in
  {
    inherit name;
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        eqyiel
        ma27
      ];
    };

    imports = [ testBase ];

    nodes = {
      nextcloud =
        { config, pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.jq ];
          services.nextcloud = {
            caching = {
              apcu = false;
              redis = true;
              memcached = false;
            };
            # This test also validates that we can use an "external" database
            database.createLocally = false;
            config = {
              dbtype = "pgsql";
              dbname = "nextcloud";
              dbuser = adminuser;
              dbpassFile = config.services.nextcloud.config.adminpassFile;
            };

            secretFile = "/etc/nextcloud-secrets.json";

            settings = {
              allow_local_remote_servers = true;
              redis = {
                dbindex = 0;
                timeout = 1.5;
                # password handled via secretfile below
              };
            };
            configureRedis = true;
          };

          services.redis.servers."nextcloud" = {
            enable = true;
            port = 6379;
            requirePass = "secret";
          };

          systemd.services.nextcloud-setup = {
            requires = [ "postgresql.service" ];
            after = [ "postgresql.service" ];
          };

          services.postgresql = {
            enable = true;
            package = pkgs.postgresql_14;
          };
          systemd.services.postgresql.postStart = pkgs.lib.mkAfter ''
            password=$(cat ${config.services.nextcloud.config.dbpassFile})
            ${config.services.postgresql.package}/bin/psql <<EOF
              CREATE ROLE ${adminuser} WITH LOGIN PASSWORD '$password' CREATEDB;
              CREATE DATABASE nextcloud;
              GRANT ALL PRIVILEGES ON DATABASE nextcloud TO ${adminuser};
            EOF
          '';

          # This file is meant to contain secret options which should
          # not go into the nix store. Here it is just used to set the
          # redis password.
          environment.etc."nextcloud-secrets.json".text = ''
            {
              "redis": {
                "password": "secret"
              }
            }
          '';
        };
    };

    test-helpers.extraTests = ''
      with subtest("non-empty redis cache"):
          # redis cache should not be empty
          nextcloud.fail('test 0 -lt "$(redis-cli --pass secret --json KEYS "*" | jq "len")"')
    '';
  }
)
