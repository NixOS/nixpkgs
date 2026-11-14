{
  pkgs,
  extraInit ? "",
  extraShutdown ? "",
}:

''
  start_all()

  ${extraInit}

  server.wait_for_unit("nats.service")
  server.wait_for_unit("seaweedfs.service")
  server.wait_for_unit("meilisearch.service")
  server.wait_for_unit("postgresql.service")
  server.wait_for_unit("redis-fluxer.service")
  server.wait_for_unit("fluxer.target")

  for port in range(10000, 10006):
    server.wait_for_open_port(port)

  for port in range(10010, 10020):
    server.wait_for_open_port(port)

  # Health checks
  client.succeed("curl --fail https://fluxer.local/_health")
  client.succeed("curl --fail https://fluxer.local/avatars/0.png --output /dev/null")

  # api
  server.succeed("curl --fail http://localhost:10000/_health")

  # api-worker
  server.succeed("find /tmp/ -name fluxer-worker-heartbeat -newermt '-30 seconds' | grep -q .")

  # admin
  server.succeed("curl --fail http://localhost:10001/_health")

  # gateway
  server.succeed("curl --fail http://localhost:10002/_health/ready")

  # media-proxy
  server.succeed("FLUXER_MEDIA_PROXY_PORT=10003 ${pkgs.fluxer-server}/bin/fluxer-media-proxy healthcheck")

  # push
  server.succeed("FLUXER_PUSH_SERVICE_PORT=10005 ${pkgs.fluxer-server}/bin/fluxer-push healthcheck")

  # app-proxy
  server.succeed("curl --fail http://localhost:10004/_health")

  for port in range(10010, 10020):
    server.succeed(f"curl --fail http://localhost:{port}/_health")

  server.shutdown()
  client.shutdown()

  ${extraShutdown}
''
