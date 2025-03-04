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
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
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
              inherit notify_push notes;
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
          client.execute("${pkgs.lib.getExe pkgs.nextcloud-notify_push.passthru.test_client} http://nextcloud ${config.adminuser} ${config.adminpass} >&2 &")
          nextcloud.wait_until_succeeds("journalctl -u nextcloud-notify_push | grep -q \"Sending ping to ${config.adminuser}\"")

      with subtest("Redis is used for caching"):
          # redis cache should not be empty
          nextcloud.fail('test "[]" = "$(redis-cli --json KEYS "*")"')

      with subtest("No code is returned when requesting PHP files (regression test)"):
          nextcloud.fail("curl -f http://nextcloud/nix-apps/notes/lib/AppInfo/Application.php")
    '';
  }
)
