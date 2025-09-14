{ lib, ... }:
{
  name = "thumbor";

  meta = {
    maintainers = [ lib.maintainers.sephi ];
  };

  nodes.machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.thumbor = {
        enable = true;
      };

      specialisation.withConfig.configuration = {
        services.thumbor.settings.HEALTHCHECK_ROUTE = "/status";
      };

      specialisation.withEnvironmentVariable.configuration = {
        services.thumbor.environmentFile = builtins.toString (
          pkgs.writeText "thumbor_environment" ''
            HEALTHCHECK_ROUTE="/status-test"
          ''
        );
      };
    };

  testScript =
    { nodes, ... }:
    let
      withConfig = "${nodes.machine.system.build.toplevel}/specialisation/withConfig";
      withEnvironmentVariable = "${nodes.machine.system.build.toplevel}/specialisation/withEnvironmentVariable";
    in
    ''
      def wait_for_thumbor():
        machine.wait_for_unit("thumbor.service")

      with subtest("healthcheck"):
        wait_for_thumbor()
        machine.wait_until_succeeds("curl --fail -s http://localhost:8888/healthcheck", timeout=30)

      with subtest("healthcheck with configuration"):
        machine.succeed("${withConfig}/bin/switch-to-configuration test >&2")
        wait_for_thumbor()
        machine.wait_until_succeeds("curl --fail -s http://localhost:8888/status", timeout=30)

      with subtest("healthcheck with configuration"):
        machine.succeed("${withEnvironmentVariable}/bin/switch-to-configuration test >&2")
        wait_for_thumbor()
        machine.wait_until_succeeds("curl --fail -s http://localhost:8888/status-test", timeout=30)
    '';
}
