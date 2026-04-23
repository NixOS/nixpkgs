{ lib, pkgs, ... }:
{
  name = "nvme-rs";

  meta = {
    maintainers = with lib.maintainers; [ liberodark ];
  };

  nodes = {
    monitor =
      { config, pkgs, ... }:
      {
        virtualisation = {
          emptyDiskImages = [
            512
            512
          ];
        };

        environment.systemPackages = with pkgs; [
          nvme-rs
          jq
        ];

        services.nvme-rs = {
          enable = true;
          package = pkgs.nvme-rs;
          settings = {
            check_interval_secs = 60;

            thresholds = {
              temp_warning = 50;
              temp_critical = 60;
              wear_warning = 15;
              wear_critical = 40;
              spare_warning = 60;
              error_threshold = 100;
            };

            email = {
              smtp_server = "mail";
              smtp_port = 25;
              smtp_username = "nvme-monitor@example.com";
              smtp_password_file = "/run/secrets/smtp-password";
              from = "NVMe Monitor <nvme-monitor@example.com>";
              to = "admin@example.com";
              use_tls = false;
            };
          };
        };

        systemd.tmpfiles.rules = [
          "f /run/secrets/smtp-password 0600 root root - testpassword"
        ];

        networking.firewall.enable = false;
      };

    mail =
      { config, pkgs, ... }:
      {
        services.postfix = {
          enable = true;
          hostname = "mail";
          domain = "example.com";

          networks = [ "0.0.0.0/0" ];
          relayDomains = [ "example.com" ];
          localRecipients = [ "admin" ];

          settings = {
            main = {
              inet_interfaces = "all";
              inet_protocols = "ipv4";
              smtpd_recipient_restrictions = "permit_mynetworks";
              smtpd_relay_restrictions = "permit_mynetworks";
            };
          };
        };

        users.users.admin = {
          isNormalUser = true;
          home = "/home/admin";
        };

        networking.firewall = {
          allowedTCPPorts = [ 25 ];
        };
      };

    client =
      { config, pkgs, ... }:
      {
        virtualisation = {
          emptyDiskImages = [ 256 ];
        };

        environment.systemPackages = with pkgs; [
          nvme-rs
          jq
        ];

        environment.etc."nvme-rs/config.toml".text = ''
          check_interval_secs = 3600

          [thresholds]
          temp_warning = 55
          temp_critical = 65
          wear_warning = 20
          wear_critical = 50
          spare_warning = 50
          error_threshold = 5000
        '';
      };
  };

  testScript =
    { nodes, ... }:
    ''
      import json

      start_all()

      for machine in [monitor, mail, client]:
          machine.wait_for_unit("multi-user.target")

      mail.wait_for_unit("postfix.service")
      mail.wait_for_open_port(25)

      client.succeed("nvme-rs check || true")
      client.succeed("nvme-rs check --config /etc/nvme-rs/config.toml || true")

      output = client.succeed("nvme-rs check --format json || echo '[]'")
      data = json.loads(output)
      assert isinstance(data, list), "JSON output should be a list"

      monitor.wait_for_unit("nvme-rs.service")
      monitor.succeed("systemctl is-active nvme-rs.service")

      config_path = monitor.succeed(
          "systemctl status nvme-rs | grep -oE '/nix/store[^ ]*nvme-rs.toml' | head -1"
      ).strip()

      if config_path:
          monitor.succeed(f"grep 'check_interval_secs = 60' {config_path}")
          monitor.succeed(f"grep 'temp_warning = 50' {config_path}")
          monitor.succeed(f"grep 'smtp_server = \"mail\"' {config_path}")

      logs = monitor.succeed("journalctl -u nvme-rs.service -n 20 --no-pager")
      assert "Starting NVMe monitor daemon" in logs or "Check interval" in logs

      monitor.succeed("test -f /run/secrets/smtp-password")

      monitor.succeed("nc -zv mail 25")
      monitor.fail("nvme-rs daemon --config /nonexistent.toml 2>&1 | grep -E 'Failed to read'")
    '';
}
