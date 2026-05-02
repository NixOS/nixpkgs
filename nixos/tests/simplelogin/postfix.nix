{ pkgs, ... }:
{
  name = "simplelogin-postfix";

  nodes.server =
    { pkgs, ... }:
    {
      services.simplelogin = {
        enable = true;
        hostName = "sl.test";
        url = "http://sl.test";
        emailDomain = "example.test";
        supportEmail = "support@example.test";
        flaskSecret = "0123456789abcdef0123456789abcdef";
        dkimKeyFile = pkgs.writeText "dkim.key" ''
          dummy
        '';
        nginx.enable = false;
        settings = {
          NOT_SEND_EMAIL = true;
          DISABLE_REGISTRATION = true;
          DISABLE_ONBOARDING = true;
        };
      };

      networking.extraHosts = ''
        127.0.0.1 sl.test
      '';

      environment.systemPackages = [
        (pkgs.writers.writePython3Bin "seed-simplelogin" { } ''
          from server import create_light_app
          from app.db import Session
          from app.models import User, Mailbox, Alias
          with create_light_app().app_context():
              user = User.create(email="alice@localhost", password="x", activated=True)
              Session.commit()
              mailbox = Mailbox.create(user_id=user.id, email="alice@localhost", verified=True)
              Session.commit()
              Alias.create(
                  user_id=user.id,
                  mailbox_id=mailbox.id,
                  email="hello",
                  enabled=True,
              )
              Session.commit()
        '')
        (pkgs.writers.writePython3Bin "send-testmail" { } ''
          import smtplib
          with smtplib.SMTP("127.0.0.1", 25) as smtp:
              smtp.sendmail("bob@remote.test", "hello@example.test", "Subject: test\\n\\nhello")
        '')
      ];
    };

  testScript = ''
    with subtest("services start"):
        server.wait_for_unit("simplelogin-web.service")
        server.wait_for_unit("simplelogin-email-handler.service")
        server.wait_for_unit("postfix.service")
        server.wait_for_open_port(7777)

    with subtest("seed database"):
        server.succeed("seed-simplelogin")

    with subtest("email handler processes incoming mail"):
        server.succeed("send-testmail")
        server.wait_until_succeeds(
            "journalctl -u simplelogin-email-handler.service --since 'now - 2 minutes' | grep -i hello@example.test"
        )
  '';
}
