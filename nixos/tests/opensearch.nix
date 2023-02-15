let
  opensearchTest =
    import ./make-test-python.nix (
      { pkgs, lib, extraSettings ? {} }: {
        name = "opensearch";
        meta.maintainers = with pkgs.lib.maintainers; [ shyim ];

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
      });
in
{
  opensearch = opensearchTest {};
  opensearchCustomPathAndUser = opensearchTest {
    extraSettings = {
      services.opensearch.dataDir = "/var/opensearch_test";
      services.opensearch.user = "open_search";
      services.opensearch.group = "open_search";
      system.activationScripts.createDirectory = {
        text = ''
          mkdir -p "/var/opensearch_test"
          chown open_search:open_search /var/opensearch_test
          chmod 0700 /var/opensearch_test
        '';
        deps = [ "users" "groups" ];
      };
      users = {
        groups.open_search = {};
        users.open_search = {
          description = "OpenSearch daemon user";
          group = "open_search";
          isSystemUser = true;
        };
      };
    };
  };
}
