let
  opensearchTest =
    extraSettings:
    import ./make-test-python.nix (
      { pkgs, lib, ... }:
      {
        name = "opensearch";
        meta.maintainers = [ ];

        nodes.machine = lib.mkMerge [
          {
            virtualisation.memorySize = 2048;
            services.opensearch.enable = true;
          }
          extraSettings
        ];

        testScript = ''
          machine.start()
          machine.wait_for_unit("opensearch.service")
          machine.wait_for_open_port(9200)

          machine.succeed(
              "curl --fail localhost:9200"
          )
        '';
      }
    );
in
{
  opensearch = opensearchTest { };
  opensearchCustomPathAndUser = opensearchTest {
    services.opensearch.dataDir = "/var/opensearch_test";
    services.opensearch.user = "open_search";
    services.opensearch.group = "open_search";
    systemd.tmpfiles.rules = [
      "d /var/opensearch_test 0700 open_search open_search -"
    ];
    users = {
      groups.open_search = { };
      users.open_search = {
        description = "OpenSearch daemon user";
        group = "open_search";
        isSystemUser = true;
      };
    };
  };
}
