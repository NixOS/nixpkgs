{
  name,
  pkgs,
  testBase,
  system,
  ...
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest (
  { config, lib, ... }:
  {
    inherit name;
    meta.maintainers = lib.teams.nextcloud.members;

    imports = [ testBase ];

    nodes = {
      nextcloud =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          environment.systemPackages = [ pkgs.jq ];
          services.nextcloud = {
            caching = {
              apcu = false;
              redis = true;
              memcached = false;
            };
            config.dbtype = "pgsql";
            notify_push = {
              enable = true;
              bendDomainToLocalhost = true;
              logLevel = "debug";
            };
            extraAppsEnable = true;
            extraApps = with config.services.nextcloud.package.packages.apps; {
              inherit notes;
            };
            settings.trusted_proxies = [ "::1" ];
          };

          services.redis.servers."nextcloud".enable = true;
          services.redis.servers."nextcloud".port = 6379;
        };
    };

    test-helpers.init =
      let
        configureRedis = pkgs.writeScript "configure-redis" ''
          nextcloud-occ config:system:set redis 'host' --value 'localhost' --type string
          nextcloud-occ config:system:set redis 'port' --value 6379 --type integer
          nextcloud-occ config:system:set memcache.local --value '\OC\Memcache\Redis' --type string
          nextcloud-occ config:system:set memcache.locking --value '\OC\Memcache\Redis' --type string
        '';
      in
      ''
        nextcloud.succeed("${configureRedis}")
      '';

    test-helpers.extraTests = ''
      with subtest("notify-push"):
          client.execute("${lib.getExe pkgs.nextcloud-notify_push.passthru.test_client} http://nextcloud ${config.adminuser} ${config.adminpass} >&2 &")
          nextcloud.wait_until_succeeds("journalctl -u nextcloud-notify_push | grep -q \"Sending ping to ${config.adminuser}\"")

      with subtest("Redis is used for caching"):
          # redis cache should not be empty
          assert nextcloud.succeed('redis-cli --json KEYS "*" | jq length').strip() != "0", """
            redis-cli for keys * returned 0 entries
          """

      with subtest("No code is returned when requesting PHP files (regression test)"):
          nextcloud.fail("curl -f http://nextcloud/nix-apps/notes/lib/AppInfo/Application.php")
    '';
  }
)
