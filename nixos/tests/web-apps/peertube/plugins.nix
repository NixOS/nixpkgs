import ../../make-test-python.nix ({ pkgs, ... }: {
  name = "peertube-plugins";
  meta.maintainers = with pkgs.lib.maintainers; [ a-kenji sbruder ];

  nodes = {
    server = { lib, pkgs, ... }: {
      services.peertube = {
        enable = true;
        localDomain = "peertube.local";
        enableWebHttps = false;

        database.createLocally = true;
        redis.createLocally = true;

        plugins = with pkgs.peertube.plugins; [
          peertube-plugin-hello-world
        ];
      };
      specialisation = {
        no-plugins.configuration = {
          services.peertube.plugins = lib.mkForce [ ];
        };
      };
    };
  };

  testScript = { nodes, ... }: ''
    import json
    import re


    def get_config():
        content = server.succeed("curl --fail http://localhost:9000/")
        return json.loads(
            json.loads(
                '"'
                + re.search(
                    r'<script type="application\/javascript">window.PeerTubeServerConfig = "(.*?)"<\/script>',
                    content,
                ).group(1)
                + '"'
            )
        )


    server.start()

    # This waits for the peertube service starting,
    # getting stopped by the plugin provisioning script
    # and starting again.
    server.wait_for_open_port(9000)
    server.wait_for_closed_port(9000)
    server.wait_for_open_port(9000)

    config = get_config()

    plugins = config["plugin"]["registered"]
    assert len(plugins) == 1

    hello_world_plugin = plugins[0]
    assert hello_world_plugin["npmName"] == "peertube-plugin-hello-world"
    assert (
        hello_world_plugin["version"]
        == "${pkgs.peertube.plugins.peertube-plugin-hello-world.version}"
    )

    client_scripts = [
        f'http://localhost:9000/plugins/hello-world/{hello_world_plugin["version"]}/client-scripts/{script["script"]}'
        for script in hello_world_plugin["clientScripts"].values()
    ]
    server.succeed(f"curl --fail {client_scripts[0]}")

    server.succeed(
        "${nodes.server.config.system.build.toplevel}/specialisation/no-plugins/bin/switch-to-configuration test >&2"
    )

    # This again waits for peertube to be restarted
    server.wait_for_closed_port(9000)
    server.wait_for_open_port(9000)

    config = get_config()

    assert len(config["plugin"]["registered"]) == 0
  '';
})
