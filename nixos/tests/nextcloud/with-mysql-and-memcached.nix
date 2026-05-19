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
        { config, pkgs, ... }:
        {
          services.nextcloud = {
            caching = {
              apcu = true;
              memcached = true;
            };
            config.dbtype = "mysql";
            configureRedis = false;
          };

          services.memcached.enable = true;
        };
    };

    test-helpers.init =
      let
        configureMemcached = pkgs.writeScript "configure-memcached" ''
          nextcloud-occ config:system:set memcached_servers 0 0 --value 127.0.0.1 --type string
          nextcloud-occ config:system:set memcached_servers 0 1 --value 11211 --type integer
          nextcloud-occ config:system:set memcache.local --value '\OC\Memcache\APCu' --type string
          nextcloud-occ config:system:set memcache.distributed --value '\OC\Memcache\Memcached' --type string
        '';
      in
      ''
        nextcloud.succeed("${configureMemcached}")
      '';
  }
)
