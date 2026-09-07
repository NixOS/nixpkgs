{ lib, ... }:
{
  name = "rsshub";

  meta.maintainers = with lib.maintainers; [ vonfry ];

  nodes = {
    basic = {
      services.rsshub.enable = true;
    };

    redis = {
      services.rsshub = {
        enable = true;

        redis = {
          enable = true;
          createLocally = true;
        };
      };
    };
  };

  testScript =
    { nodes, ... }:
    let
      port = nodes.basic.services.rsshub.settings.PORT;
    in
    ''
      def assert_http_200(machine, url):
        code = machine.succeed(f"curl -s -o /dev/null -w '%{{http_code}}' {url}").strip()
        assert code == "200", f"Expected HTTP 200 from {url}, got {code}"

      def test_node(node):
        node.wait_for_unit("rsshub.service")
        node.wait_for_open_port(${port})
        assert_http_200(node, "http://localhost:${port}/healthz")

      with subtest("RSSHub works"):
        test_node(basic)

      with subtest("RSSHub works with local Redis"):
        test_node(redis)

    '';
}
