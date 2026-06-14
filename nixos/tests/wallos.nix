{ pkgs, ... }:

{
  name = "wallos";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ iokernel ];
  };

  nodes.machine = {
    services.wallos = {
      enable = true;
      virtualHostName = "wallos.local";
      listenPort = 80;
      openFirewall = true;
      admin = {
        maxUsers = 3;
        registrationsOpen = true;
        requireEmailVerification = true;
        serverUrl = "https://wallos.local";
        updateNotification = true;
        smtp = {
          address = "smtp.example";
          port = 465;
          encryption = "ssl";
          username = "smtp-user";
          passwordFile = "/etc/wallos/smtp-password";
          fromEmail = "wallos@example";
        };
        localWebhookAllowlist = [
          "192.168.1.100"
          "homeassistant.local"
        ];
      };
      oidc = {
        enable = true;
        providerName = "Test Provider";
        clientIdFile = "/etc/wallos/oidc-client-id";
        clientSecretFile = "/etc/wallos/oidc-client-secret";
        authorizeUrl = "https://idp.example/authorize";
        tokenUrl = "https://idp.example/token";
        userInfoUrl = "https://idp.example/userinfo";
        redirectUrl = "https://wallos.local/index.php";
        logoutUrl = "https://idp.example/logout";
        userIdentifierField = "sub";
        scopes = [
          "openid"
          "email"
          "profile"
          "groups"
        ];
        autoCreateUser = true;
        passwordLoginDisabled = true;
      };
    };

    services.nginx.enable = true;

    environment.etc = {
      "wallos/smtp-password".text = "smtp-password\n";
      "wallos/oidc-client-id".text = "test-client-id\n";
      "wallos/oidc-client-secret".text = "test-client-secret\n";
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("wallos-init.service")
    machine.wait_for_unit("phpfpm-wallos.service")
    machine.wait_for_unit("nginx.service")

    # Declarative admin settings bootstrap wrote admin.php settings.
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT registrations_open, max_users, require_email_verification, server_url, login_disabled, update_notification FROM admin WHERE id = 1;\" | grep '^1|3|1|https://wallos.local|0|1$'")
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT smtp_address, smtp_port, encryption, smtp_username, smtp_password, from_email FROM admin WHERE id = 1;\" | grep '^smtp.example|465|ssl|smtp-user|smtp-password|wallos@example$'")
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT local_webhook_notifications_allowlist FROM admin WHERE id = 1;\" | grep '^192.168.1.100,homeassistant.local$'")

    # OIDC bootstrap wrote upstream Wallos oauth_settings fields.
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT oidc_oauth_enabled FROM admin;\" | grep '^1$'")
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT name FROM oauth_settings WHERE id = 1;\" | grep '^Test Provider$'")
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT client_id FROM oauth_settings WHERE id = 1;\" | grep '^test-client-id$'")
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT client_secret FROM oauth_settings WHERE id = 1;\" | grep '^test-client-secret$'")
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT authorization_url FROM oauth_settings WHERE id = 1;\" | grep '^https://idp.example/authorize$'")
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT scopes FROM oauth_settings WHERE id = 1;\" | grep '^openid email profile groups$'")
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT auto_create_user, password_login_disabled FROM oauth_settings WHERE id = 1;\" | grep '^1|1$'")

    # Health check endpoint.
    machine.succeed("curl -fsS http://127.0.0.1/health.php | grep OK")

    # Login/registration page loads.
    machine.succeed("curl -fsSL http://127.0.0.1/login.php | grep -i wallos")

    # Nginx protects sensitive database and writable PHP paths.
    machine.succeed("test \"$(curl -sS -o /dev/null -w '%{http_code}' http://127.0.0.1/db/wallos.db)\" = 403")
    machine.succeed("mkdir -p /var/lib/wallos/logos/security-test /var/lib/wallos/tmp")
    machine.succeed("printf '%s\n' '<?php echo \"bad\"; ?>' > /var/lib/wallos/logos/security-test/probe.php")
    machine.succeed("printf '%s\n' '<?php echo \"bad\"; ?>' > /var/lib/wallos/tmp/probe.php")
    machine.succeed("test \"$(curl -sS -o /dev/null -w '%{http_code}' http://127.0.0.1/images/uploads/logos/security-test/probe.php)\" = 403")
    machine.succeed("test \"$(curl -sS -o /dev/null -w '%{http_code}' http://127.0.0.1/.tmp/probe.php)\" = 403")

    # At least one upstream cron job can execute under systemd hardening.
    machine.succeed("systemctl start wallos-cron-cleanupresettokens.service")

    # Database and migrations exist.
    machine.succeed("test -f /var/lib/wallos/db/wallos.db")
    machine.succeed("${pkgs.sqlite}/bin/sqlite3 /var/lib/wallos/db/wallos.db \"SELECT name FROM sqlite_master WHERE type='table' AND name='migrations';\"")

    # Runtime webroot uses persistent state links.
    machine.succeed("test -d /run/wallos/root")
    machine.succeed("test -L /run/wallos/root/db")
    machine.succeed("test -L /run/wallos/root/images/uploads/logos")
    machine.succeed("test -L /run/wallos/root/.tmp")
    machine.succeed("test -f /run/wallos/root/db/wallos.db")
  '';
}
