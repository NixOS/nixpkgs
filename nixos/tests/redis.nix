{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },

  lib ? pkgs.lib,
}:
let
  makeTest = import ./make-test-python.nix;
  mkTestName =
    pkg: "${pkg.pname}_${builtins.replaceStrings [ "." ] [ "" ] (lib.versions.majorMinor pkg.version)}";
  redisPackages = {
    inherit (pkgs) redis keydb valkey;
  };
  makeRedisTest =
    {
      package,
      name ? mkTestName package,
    }:
    makeTest {
      inherit name;
      meta.maintainers = [
        lib.maintainers.flokli
      ]
      ++ lib.teams.helsinki-systems.members;

      nodes = {
        machine =
          { lib, ... }:

          {
            services = {
              redis = {
                inherit package;
                servers."".enable = true;
                servers."test".enable = true;
              };
            };

            users.users = lib.listToAttrs (
              map
                (
                  suffix:
                  lib.nameValuePair "member${suffix}" {
                    createHome = false;
                    description = "A member of the redis${suffix} group";
                    isNormalUser = true;
                    extraGroups = [ "redis${suffix}" ];
                  }
                )
                [
                  ""
                  "-test"
                ]
            );
          };
      };

      testScript =
        { nodes, ... }:
        let
          inherit (nodes.machine.services) redis;
        in
        ''
          start_all()
          machine.wait_for_unit("redis")
          machine.wait_for_unit("redis-test")

          # The unnamed Redis server still opens a port for backward-compatibility
          machine.wait_for_open_port(6379)

          machine.wait_for_file("${redis.servers."".unixSocket}")
          machine.wait_for_file("${redis.servers."test".unixSocket}")

          # The unix socket is accessible to the redis group
          machine.succeed('su member -c "${pkgs.redis}/bin/redis-cli ping | grep PONG"')
          machine.succeed('su member-test -c "${pkgs.redis}/bin/redis-cli ping | grep PONG"')

          machine.succeed("${pkgs.redis}/bin/redis-cli ping | grep PONG")
          machine.succeed("${pkgs.redis}/bin/redis-cli -s ${redis.servers."".unixSocket} ping | grep PONG")
          machine.succeed("${pkgs.redis}/bin/redis-cli -s ${
            redis.servers."test".unixSocket
          } ping | grep PONG")
        '';
    };
in
lib.mapAttrs (_: package: makeRedisTest { inherit package; }) redisPackages
