let
  redisPort = 6379;
  centrifugoPort = 8080;
  nodes = [
    "centrifugo1"
    "centrifugo2"
    "centrifugo3"
  ];
in
{ lib, ... }: {
  name = "centrifugo";
  meta.maintainers = [ lib.maintainers.tie ];

  nodes = lib.listToAttrs (lib.imap0
    (index: name: {
      inherit name;
      value = { config, ... }: {
        services.centrifugo = {
          enable = true;
          settings = {
            inherit name;
            port = centrifugoPort;
            # See https://centrifugal.dev/docs/server/engines#redis-sharding
            engine = "redis";
            # Connect to local Redis shard via Unix socket.
            redis_address =
              let
                otherNodes = lib.take index nodes ++ lib.drop (index + 1) nodes;
              in
              map (name: "${name}:${toString redisPort}") otherNodes ++ [
                "unix://${config.services.redis.servers.centrifugo.unixSocket}"
              ];
            usage_stats_disable = true;
            api_insecure = true;
          };
          extraGroups = [
            config.services.redis.servers.centrifugo.user
          ];
        };
        services.redis.servers.centrifugo = {
          enable = true;
          bind = null; # all interfaces
          port = redisPort;
          openFirewall = true;
          settings.protected-mode = false;
        };
      };
    })
    nodes);

  testScript = ''
    import json

    redisPort = ${toString redisPort}
    centrifugoPort = ${toString centrifugoPort}

    start_all()

    for machine in machines:
      machine.wait_for_unit("redis-centrifugo.service")
      machine.wait_for_open_port(redisPort)

    for machine in machines:
      machine.wait_for_unit("centrifugo.service")
      machine.wait_for_open_port(centrifugoPort)

    # See https://centrifugal.dev/docs/server/server_api#info
    def list_nodes(machine):
      curl = "curl --fail-with-body --silent"
      body = "{}"
      resp = json.loads(machine.succeed(f"{curl} -d '{body}' http://localhost:{centrifugoPort}/api/info"))
      return resp["result"]["nodes"]
    machineNames = {m.name for m in machines}
    for machine in machines:
      nodes = list_nodes(machine)
      assert len(nodes) == len(machines)
      nodeNames = {n['name'] for n in nodes}
      assert machineNames == nodeNames
  '';
}
