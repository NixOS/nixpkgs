import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "influxdb2";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ offline ];
    };

    nodes.machine =
      { lib, ... }:
      {
        environment.systemPackages = [ pkgs.influxdb2-cli ];
        # Make sure that the service is restarted immediately if tokens need to be rewritten
        # without relying on any Restart=on-failure behavior
        systemd.services.influxdb2.serviceConfig.RestartSec = 6000;
        services.influxdb2.enable = true;
        services.influxdb2.provision = {
          enable = true;
          initialSetup = {
            organization = "default";
            bucket = "default";
            passwordFile = pkgs.writeText "admin-pw" "ExAmPl3PA55W0rD";
            tokenFile = pkgs.writeText "admin-token" "verysecureadmintoken";
          };
          organizations.someorg = {
            buckets.somebucket = { };
            auths.sometoken = {
              description = "some auth token";
              readBuckets = [ "somebucket" ];
              writeBuckets = [ "somebucket" ];
            };
          };
          users.someuser.passwordFile = pkgs.writeText "tmp-pw" "abcgoiuhaoga";
        };

        specialisation.withModifications.configuration =
          { ... }:
          {
            services.influxdb2.provision = {
              organizations.someorg.buckets.somebucket.present = false;
              organizations.someorg.auths.sometoken.present = false;
              users.someuser.present = false;

              organizations.myorg = {
                description = "Myorg description";
                buckets.mybucket = {
                  description = "Mybucket description";
                };
                auths.mytoken = {
                  operator = true;
                  description = "operator token";
                  tokenFile = pkgs.writeText "tmp-tok" "someusertoken";
                };
              };
              users.myuser.passwordFile = pkgs.writeText "tmp-pw" "abcgoiuhaoga";
            };
          };

        specialisation.withParentDelete.configuration =
          { ... }:
          {
            services.influxdb2.provision = {
              organizations.someorg.present = false;
              # Deleting the parent implies:
              #organizations.someorg.buckets.somebucket.present = false;
              #organizations.someorg.auths.sometoken.present = false;
            };
          };

        specialisation.withNewTokens.configuration =
          { ... }:
          {
            services.influxdb2.provision = {
              organizations.default = {
                auths.operator = {
                  operator = true;
                  description = "new optoken";
                  tokenFile = pkgs.writeText "tmp-tok" "newoptoken";
                };
                auths.allaccess = {
                  operator = true;
                  description = "new allaccess";
                  tokenFile = pkgs.writeText "tmp-tok" "newallaccess";
                };
                auths.specifics = {
                  description = "new specifics";
                  readPermissions = [
                    "users"
                    "tasks"
                  ];
                  writePermissions = [ "tasks" ];
                  tokenFile = pkgs.writeText "tmp-tok" "newspecificstoken";
                };
              };
            };
          };
      };

    testScript =
      { nodes, ... }:
      let
        specialisations = "${nodes.machine.system.build.toplevel}/specialisation";
        tokenArg = "--token verysecureadmintoken";
      in
      ''
        def assert_contains(haystack, needle):
            if needle not in haystack:
                print("The haystack that will cause the following exception is:")
                print("---")
                print(haystack)
                print("---")
                raise Exception(f"Expected string '{needle}' was not found")

        def assert_lacks(haystack, needle):
            if needle in haystack:
                print("The haystack that will cause the following exception is:")
                print("---")
                print(haystack, end="")
                print("---")
                raise Exception(f"Unexpected string '{needle}' was found")

        machine.wait_for_unit("influxdb2.service")

        machine.fail("curl --fail -X POST 'http://localhost:8086/api/v2/signin' -u admin:wrongpassword")
        machine.succeed("curl --fail -X POST 'http://localhost:8086/api/v2/signin' -u admin:ExAmPl3PA55W0rD")

        out = machine.succeed("influx org list ${tokenArg}")
        assert_contains(out, "default")
        assert_lacks(out, "myorg")
        assert_contains(out, "someorg")

        out = machine.succeed("influx bucket list ${tokenArg} --org default")
        assert_contains(out, "default")

        machine.fail("influx bucket list ${tokenArg} --org myorg")

        out = machine.succeed("influx bucket list ${tokenArg} --org someorg")
        assert_contains(out, "somebucket")

        out = machine.succeed("influx user list ${tokenArg}")
        assert_contains(out, "admin")
        assert_lacks(out, "myuser")
        assert_contains(out, "someuser")

        out = machine.succeed("influx auth list ${tokenArg}")
        assert_lacks(out, "operator token")
        assert_contains(out, "some auth token")

        with subtest("withModifications"):
          machine.succeed('${specialisations}/withModifications/bin/switch-to-configuration test')
          machine.wait_for_unit("influxdb2.service")

          out = machine.succeed("influx org list ${tokenArg}")
          assert_contains(out, "default")
          assert_contains(out, "myorg")
          assert_contains(out, "someorg")

          out = machine.succeed("influx bucket list ${tokenArg} --org myorg")
          assert_contains(out, "mybucket")

          out = machine.succeed("influx bucket list ${tokenArg} --org someorg")
          assert_lacks(out, "somebucket")

          out = machine.succeed("influx user list ${tokenArg}")
          assert_contains(out, "admin")
          assert_contains(out, "myuser")
          assert_lacks(out, "someuser")

          out = machine.succeed("influx auth list ${tokenArg}")
          assert_contains(out, "operator token")
          assert_lacks(out, "some auth token")

          # Make sure the user token is also usable
          machine.succeed("influx auth list --token someusertoken")

        with subtest("keepsUnrelated"):
          machine.succeed('${nodes.machine.system.build.toplevel}/bin/switch-to-configuration test')
          machine.wait_for_unit("influxdb2.service")

          out = machine.succeed("influx org list ${tokenArg}")
          assert_contains(out, "default")
          assert_contains(out, "myorg")
          assert_contains(out, "someorg")

          out = machine.succeed("influx bucket list ${tokenArg} --org default")
          assert_contains(out, "default")

          out = machine.succeed("influx bucket list ${tokenArg} --org myorg")
          assert_contains(out, "mybucket")

          out = machine.succeed("influx bucket list ${tokenArg} --org someorg")
          assert_contains(out, "somebucket")

          out = machine.succeed("influx user list ${tokenArg}")
          assert_contains(out, "admin")
          assert_contains(out, "myuser")
          assert_contains(out, "someuser")

          out = machine.succeed("influx auth list ${tokenArg}")
          assert_contains(out, "operator token")
          assert_contains(out, "some auth token")

        with subtest("withParentDelete"):
          machine.succeed('${specialisations}/withParentDelete/bin/switch-to-configuration test')
          machine.wait_for_unit("influxdb2.service")

          out = machine.succeed("influx org list ${tokenArg}")
          assert_contains(out, "default")
          assert_contains(out, "myorg")
          assert_lacks(out, "someorg")

          out = machine.succeed("influx bucket list ${tokenArg} --org default")
          assert_contains(out, "default")

          out = machine.succeed("influx bucket list ${tokenArg} --org myorg")
          assert_contains(out, "mybucket")

          machine.fail("influx bucket list ${tokenArg} --org someorg")

          out = machine.succeed("influx user list ${tokenArg}")
          assert_contains(out, "admin")
          assert_contains(out, "myuser")
          assert_contains(out, "someuser")

          out = machine.succeed("influx auth list ${tokenArg}")
          assert_contains(out, "operator token")
          assert_lacks(out, "some auth token")

        with subtest("withNewTokens"):
          machine.succeed('${specialisations}/withNewTokens/bin/switch-to-configuration test')
          machine.wait_for_unit("influxdb2.service")

          out = machine.succeed("influx auth list ${tokenArg}")
          assert_contains(out, "operator token")
          assert_contains(out, "some auth token")
          assert_contains(out, "new optoken")
          assert_contains(out, "new allaccess")
          assert_contains(out, "new specifics")
      '';
  }
)
