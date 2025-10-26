let
  trustDomain = "example.com";
in
{
  name = "spire";

  nodes = {
    server =
      { config, ... }:
      {
        networking.domain = trustDomain;
        services.spire.server = {
          enable = true;
          openFirewall = true;
          settings = {
            server.trust_domain = trustDomain;
            plugins = {
              KeyManager.memory.plugin_data = { };
              DataStore.sql.plugin_data = {
                database_type = "sqlite3";
                connection_string = "$STATE_DIRECTORY/datastore.sqlite3";
              };
              NodeAttestor.join_token.plugin_data = { };
            };
          };
        };
      };

    agent = {
      virtualisation.credentials = {
        "spire.join_token".source = "./join_token";
        "spire.trust_bundle".source = "./trust_bundle";
      };

      systemd.services.spire-agent.serviceConfig.ImportCredential = [
        "spire.join_token"
        "spire.trust_bundle"
      ];

      services.spire.agent = {
        enable = true;
        settings = {
          agent = {
            trust_domain = trustDomain;
            server_address = "server.${trustDomain}";
            join_token_file = "$CREDENTIALS_DIRECTORY/spire.join_token";
            trust_bundle_format = "pem";
            trust_bundle_path = "$CREDENTIALS_DIRECTORY/spire.trust_bundle";
          };
          plugins = {
            KeyManager.memory.plugin_data = { };
            NodeAttestor.join_token.plugin_data = { };
            WorkloadAttestor.systemd.plugin_data = { };
            WorkloadAttestor.unix.plugin_data = { };
          };
        };
      };
    };
  };

  testScript =
    { nodes }:
    let
      adminSocket = nodes.server.services.spire.server.settings.server.socket_path;
      workloadSocket = nodes.agent.services.spire.agent.settings.agent.socket_path;
    in
    ''
      # TODO: instead of trust bundle to talk to the spire-server, use an upstream CA?
      def provision(agent, spiffe_id):

        # expose as system credentials
        bundle = server.succeed("spire-server bundle show -socketPath ${adminSocket}")
        with open(agent.state_dir / "trust_bundle", "w") as f:
          f.write(bundle)
        join_token = server.succeed("spire-server token generate -socketPath ${adminSocket}").split()[1]
        with open(agent.state_dir / "join_token", "w") as f:
          f.write(join_token)

        # register a workload on the node
        parent_id=f"spiffe://${trustDomain}/spire/agent/join_token/{join_token}"
        server.succeed(f"spire-server entry create -socketPath ${adminSocket} -selector 'systemd:id:backdoor.service' -parentID {parent_id} -spiffeID 'spiffe://${trustDomain}/service/backdoor'")

      with subtest("SPIRE server startup and health checks"):
        server.wait_for_unit("spire-server.service")
        server.wait_until_succeeds("spire-server healthcheck -socketPath ${adminSocket}", timeout=5)


      with subtest("Setup SPIRE agent on agent node"):
        provision(agent, "spiffe://${trustDomain}/server/agent")
        agent.wait_for_unit("spire-agent.service")
        agent.wait_until_succeeds("spire-agent healthcheck -socketPath ${workloadSocket}", timeout=5)


      with subtest("Test certificate authentication from agent node"):
        agent.succeed("spire-agent api fetch x509 -socketPath ${workloadSocket} -write .")

      # TODO: Add something to communicate with
    '';
}
