{ pkgs, ... }:
let
  trustDomain = "example.com";

  # TODO: tpm-ek test has similar stuff. Also the whole tpm provisioning should probably
  # just use the vtpm provisioning commands in the future?

  # OpenSSL config to sign the swtpm EK with TPM-specific certificate extensions
  ekSignConf = pkgs.writeText "ek-sign.cnf" ''
    [ tpm_policy ]
    basicConstraints = critical, CA:FALSE
    keyUsage = critical, keyEncipherment
    certificatePolicies = 2.23.133.2.1
    extendedKeyUsage = 2.23.133.8.1
    subjectAltName = ASN1:SEQUENCE:dirname_tpm

    [ dirname_tpm ]
    seq = EXPLICIT:4,SEQUENCE:dirname_tpm_seq

    [ dirname_tpm_seq ]
    set = SET:dirname_tpm_set

    [ dirname_tpm_set ]
    seq.1 = SEQUENCE:dirname_tpm_seq_manufacturer
    seq.2 = SEQUENCE:dirname_tpm_seq_model
    seq.3 = SEQUENCE:dirname_tpm_seq_version

    [dirname_tpm_seq_manufacturer]
    oid = OID:2.23.133.2.1
    str = UTF8:"id:53544D20"

    [dirname_tpm_seq_model]
    oid = OID:2.23.133.2.2
    str = UTF8:"ST33HTPHAHD4"

    [dirname_tpm_seq_version]
    oid = OID:2.23.133.2.3
    str = UTF8:"id:00010101"
  '';

  agent =
    { config, ... }:
    {
      environment.variables.SPIFFE_ENDPOINT_SOCKET =
        config.services.spire.agent.settings.agent.socket_path;
      virtualisation.credentials."spire.trust_bundle".source = "./trust_bundle";
      systemd.services.spire-agent.serviceConfig.ImportCredential = [ "spire.trust_bundle" ];

      # A non-root, non-spire-agent user used to verify that arbitrary
      # workloads can reach the Workload API socket.
      users.users.workload = {
        isNormalUser = true;
        group = "workload";
      };
      users.groups.workload = { };
    };

  tpmAgent =
    { pkgs, lib, ... }:
    {
      imports = [ agent ];
      virtualisation = {
        useEFIBoot = true;
        tpm = {
          enable = true;
          # Provision the swtpm with an EK certificate signed by testCA so that
          # the SPIRE server can verify the agent's identity.
          provisioning = ''
            export PATH=${
              lib.makeBinPath [
                pkgs.openssl
                pkgs.tpm2-tools
              ]
            }:$PATH

            tpm2_createek -G rsa -u ek.pub -c ek.ctx -f pem

            openssl x509 \
              -extfile ${ekSignConf} \
              -new -days 365 \
              -subj "/CN=swtpm-ekcert" \
              -extensions tpm_policy \
              -CA ${./tpm-ek/ca.crt} -CAkey ${./tpm-ek/ca.priv} \
              -out ekcert.der -outform der \
              -force_pubkey ek.pub

            tpm2_nvdefine 0x01c00002 \
              -C o \
              -a "ownerread|policyread|policywrite|ownerwrite|authread|authwrite" \
              -s "$(wc -c < ekcert.der)"

            tpm2_nvwrite 0x01c00002 -C o -i ekcert.der
          '';
        };
      };

      environment.systemPackages = [ pkgs.spire-tpm-plugin ];

      services.spire.agent = {
        enable = true;
        settings = {
          agent = {
            trust_domain = trustDomain;
            server_address = "server.${trustDomain}";
            trust_bundle_format = "pem";
            trust_bundle_path = "$CREDENTIALS_DIRECTORY/spire.trust_bundle";
          };
          plugins = {
            KeyManager.memory.plugin_data = { };
            NodeAttestor.tpm.plugin_data = { };
            WorkloadAttestor.systemd.plugin_data = { };
            WorkloadAttestor.unix.plugin_data = { };
          };
        };
      };
    };
in
{
  name = "spire";

  nodes = {
    server =
      { config, ... }:
      {
        networking.domain = trustDomain;
        environment.etc."spire/server/certs/tpm-ca.crt".source = ./tpm-ek/ca.crt;
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
              NodeAttestor.tpm.plugin_data.ca_path = "/etc/spire/server/certs";
            };
          };
        };
      };

    agent = {
      imports = [ agent ];

      virtualisation.credentials."spire.join_token".source = "./join_token";
      systemd.services.spire-agent.serviceConfig.ImportCredential = [ "spire.join_token" ];

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

    tpmAgent = tpmAgent;
    tpmSelectorAgent = tpmAgent;
  };

  testScript =
    { nodes, ... }:
    let
      adminSocket = nodes.server.services.spire.server.settings.server.socket_path;
    in
    ''
      def provision_trust_bundle(agent):
        # TODO: instead of trust bundle to talk to the spire-server, use an upstream CA?
        bundle = server.succeed("spire-server bundle show -socketPath ${adminSocket}")
        with open(agent.state_dir / "trust_bundle", "w") as f:
          f.write(bundle)


      def provision_join_token(agent):
        join_token = server.succeed("spire-server token generate -socketPath ${adminSocket}").split()[1]
        with open(agent.state_dir / "join_token", "w") as f:
          f.write(join_token)
        return f"spiffe://${trustDomain}/spire/agent/join_token/{join_token}"


      def provision_tpm(agent):
        agent.wait_for_unit("tpm2.target")
        ek_hash = agent.succeed("get_tpm_pubhash").strip()
        return f"spiffe://${trustDomain}/spire/agent/tpm/{ek_hash}"


      def provision_tpm_selector(agent):
        agent.wait_for_unit("tpm2.target")
        alias_id = "spiffe://${trustDomain}/aliased-agent/tpm-model"
        register_entry("spiffe://${trustDomain}/spire/server", "tpm:model:ST33HTPHAHD4", alias_id)
        return alias_id


      def register_entry(parent_id, selector, spiffe_id):
        server.succeed(f"spire-server entry create -socketPath ${adminSocket} -selector '{selector}' -parentID '{parent_id}' -spiffeID '{spiffe_id}'")


      def test_agent(name, agent_node, provision_fn):
        workload_spiffe_id = f"spiffe://${trustDomain}/{name}/workload"
        with subtest(f"Setup SPIRE agent with {name} attestation"):
          provision_trust_bundle(agent_node)
          parent_id = provision_fn(agent_node)
          register_entry(parent_id, "unix:user:workload", workload_spiffe_id)
          agent_node.wait_for_unit("spire-agent.service")
          agent_node.wait_until_succeeds("spire-agent healthcheck -socketPath $SPIFFE_ENDPOINT_SOCKET", timeout=90)
        with subtest(f"Workload user receives the {name} workload SVID"):
          # Each agent node is fresh, so fetch returns "no identity issued"
          # (non-zero) until exactly this entry's SVID is cached — content-aware
          # retry isn't needed.
          output = agent_node.wait_until_succeeds(
            "su -s /bin/sh workload -c "
            "'spire-agent api fetch x509 -socketPath \"$SPIFFE_ENDPOINT_SOCKET\"'"
          )
          t.assertIn(workload_spiffe_id, output)


      with subtest("SPIRE server startup and health checks"):
        server.wait_for_unit("spire-server.service")
        server.wait_until_succeeds("spire-server healthcheck -socketPath ${adminSocket}", timeout=30)


      test_agent("join_token", agent, provision_join_token)
      test_agent("tpm", tpmAgent, provision_tpm)
      test_agent("tpm-selector", tpmSelectorAgent, provision_tpm_selector)

    '';
}
