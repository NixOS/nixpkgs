{ lib, pkgs, ... }:
let
  port = 5678;
  brokerPort = 5679;
  webhookUrl = "http://example.com";
  secretFile = toString (pkgs.writeText "n8n-encryption-key" "test-encryption-key-12345");
  authTokenFile = toString (pkgs.writeText "n8n-runner-auth-token" "test-runner-auth-token-12345");
in
{
  name = "n8n";
  meta.maintainers = with lib.maintainers; [
    k900
    sweenu
    gepbird
  ];

  node.pkgsReadOnly = false;

  nodes = {
    machine_simple = {
      services.n8n.enable = true;
    };
    machine_configured = {
      services.n8n = {
        enable = true;
        customNodes = [ pkgs.n8n-nodes-carbonejs ];
        environment = {
          WEBHOOK_URL = webhookUrl;
          N8N_TEMPLATES_ENABLED = false;
          DB_PING_INTERVAL_SECONDS = 2;
          # !!! Don't do this with real keys/tokens. The /nix store is world-readable!
          N8N_ENCRYPTION_KEY_FILE = secretFile;
          N8N_RUNNERS_AUTH_TOKEN_FILE = authTokenFile;
        };
        taskRunners = {
          enable = true;
          environment = {
            # Common env var for all runners
            N8N_RUNNERS_MAX_CONCURRENCY = 10;
          };
          runners = {
            javascript = {
              args = [ "--disallow-code-generation-from-strings" ];
              environment.NODE_FUNCTION_ALLOW_BUILTIN = "*";
            };
            python = {
              args = [ "--test-arg" ];
              environment.N8N_RUNNERS_STDLIB_ALLOW = "*";
            };
          };
        };
      };
    };
  };

  testScript = ''
    machine_simple.wait_for_unit("n8n.service")
    machine_simple.wait_for_console_text("Editor is now accessible via")
    machine_simple.succeed("curl --fail -vvv http://localhost:${toString port}/")


    machine_configured.wait_for_unit("n8n.service")
    machine_configured.wait_for_console_text("Editor is now accessible via")

    # Test regular environment variables
    machine_configured.succeed("curl --fail -vvv http://localhost:${toString port}/")
    machine_configured.succeed("grep -qF ${webhookUrl} /etc/systemd/system/n8n.service")
    machine_configured.succeed("grep -qF 'HOME=/var/lib/n8n' /etc/systemd/system/n8n.service")
    machine_configured.fail("grep -qF 'GENERIC_TIMEZONE=' /etc/systemd/system/n8n.service")
    machine_configured.succeed("grep -qF 'N8N_DIAGNOSTICS_ENABLED=false' /etc/systemd/system/n8n.service")
    machine_configured.succeed("grep -qF 'N8N_TEMPLATES_ENABLED=false' /etc/systemd/system/n8n.service")
    machine_configured.succeed("grep -qF 'DB_PING_INTERVAL_SECONDS=2' /etc/systemd/system/n8n.service")

    # Test _FILE environment variables
    machine_configured.succeed("grep -qF 'LoadCredential=n8n_encryption_key_file:${secretFile}' /etc/systemd/system/n8n.service")
    machine_configured.succeed("grep -qF 'N8N_ENCRYPTION_KEY_FILE=%d/n8n_encryption_key_file' /etc/systemd/system/n8n.service")

    # Test custom nodes
    machine_configured.succeed("grep -qF 'N8N_CUSTOM_EXTENSIONS=' /etc/systemd/system/n8n.service")
    custom_extensions_dir = machine_configured.succeed("grep -oP 'N8N_CUSTOM_EXTENSIONS=\\K[^\"]+' /etc/systemd/system/n8n.service").strip()
    machine_configured.succeed(f"test -L {custom_extensions_dir}/n8n-nodes-carbonejs")
    machine_configured.succeed(f"test -f {custom_extensions_dir}/n8n-nodes-carbonejs/package.json")

    # Test task runner integration on n8n service
    machine_configured.succeed("grep -qF 'N8N_RUNNERS_MODE=external' /etc/systemd/system/n8n.service")
    machine_configured.succeed("grep -qF 'N8N_RUNNERS_BROKER_PORT=${toString brokerPort}' /etc/systemd/system/n8n.service")
    machine_configured.succeed("grep -qF 'LoadCredential=n8n_runners_auth_token_file:${authTokenFile}' /etc/systemd/system/n8n.service")

    # Test task runner service
    machine_configured.wait_for_unit("n8n-task-runner.service")
    machine_configured.succeed("systemctl is-active n8n-task-runner.service")

    # Test that both runner types are enabled
    machine_configured.succeed("grep -qF 'javascript python' /etc/systemd/system/n8n-task-runner.service")

    # Test common environment variables are passed to launcher
    machine_configured.succeed("grep -qF 'N8N_RUNNERS_MAX_CONCURRENCY=10' /etc/systemd/system/n8n-task-runner.service")
    machine_configured.succeed("grep -qF 'N8N_RUNNERS_TASK_BROKER_URI=http://127.0.0.1:${toString brokerPort}' /etc/systemd/system/n8n-task-runner.service")

    # Test auth token is loaded via credentials
    machine_configured.succeed("grep -qF 'LoadCredential=n8n_runners_auth_token_file:${authTokenFile}' /etc/systemd/system/n8n-task-runner.service")

    # Test launcher config file
    config_path = machine_configured.succeed("grep -oP 'N8N_RUNNERS_CONFIG_PATH=\\K[^[:space:]\"]+' /etc/systemd/system/n8n-task-runner.service").strip()
    config = machine_configured.succeed(f"cat {config_path}")
    assert "NODE_FUNCTION_ALLOW_BUILTIN" in config, "JavaScript env-override not in config"
    assert "N8N_RUNNERS_STDLIB_ALLOW" in config, "Python env-override not in config"
    assert "N8N_RUNNERS_MAX_CONCURRENCY" in config, "Common allowed-env not in config"
    assert "--disallow-code-generation-from-strings" in config, "JavaScript args not in config"
    assert "--test-arg" in config, "Python args not in config"
    assert '"health-check-server-port":"5681"' in config, "JavaScript health check port not in config"
    assert '"health-check-server-port":"5682"' in config, "Python health check port not in config"
  '';
}
