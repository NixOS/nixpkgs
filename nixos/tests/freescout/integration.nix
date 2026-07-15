# This tests runs freescout and performs the following tests:
# - Create amin user via the CLI
# - Create mailbox, configured for sending and receiving
# - Test if receiving, sending and notifications work
{ pkgs, lib, ... }:

let
  mailDomain = "freemail.local";
  freescoutDomain = "freescout.local";
  sendInitial = pkgs.writeShellScriptBin "send-initial" ''
    exec ${pkgs.dovecot}/libexec/dovecot/deliver -d freescout <<MAIL
    From: root@localhost
    To: freescout@localhost
    Subject: Hello NixOS!
    Message-ID: initialtestmail-$(date +%s)@localhost

    I am just a test E-Mail to see if freescout is (somewhat) working.
    MAIL
  '';

  keyFile = pkgs.writeText "freescout-app-key" "base64:J8ZgK5LZkhVKpmZvjjA700sNL7+Y6aQTus8ZnUNNAaE=";

  baseTestNode =
    {
      config,
      ...
    }:
    {
      virtualisation.memorySize = 1024;
      environment.systemPackages = with pkgs; [
        curl
        sendInitial
        jq
      ];

      networking.firewall.allowedTCPPorts = [
        80
        8025
      ];
      networking.extraHosts = ''
        127.0.0.1 ${mailDomain} ${freescoutDomain}
      '';

      services.mailhog = {
        enable = true;
        setSendmail = false;
      };

      users.users.alice = {
        isNormalUser = true;
        description = "Alice Foobar";
        password = "foobar";
        uid = 1000;
      };

      users.users.bob = {
        isNormalUser = true;
        description = "Bob Foobar";
        password = "foobar";
      };

      # Taken from from the parsedmarc.nix test
      services.postfix.enable = true;
      services.dovecot2 = {
        enable = true;
        settings = {
          dovecot_config_version = "2.4.4";
          dovecot_storage_version = "2.4.4";
          mail_uid = "vmail";
          mail_gid = "vmail";
          protocols = [
            "imap"
            "lmtp"
          ];
          mail_driver = "maildir";
          mail_home = "${config.services.postfix.settings.main.mail_spool_directory}/{user}";
          "passdb static" = {
            fields = {
              nopassword = true;
              allow_nets = "local,0.0.0.0/0,::/0";
            };
          };
        };
      };
      users.users.freescout = {
        password = "foobar2342";
      };

      services.freescout = {
        enable = true;
        domain = freescoutDomain;
        settings = {
          APP_KEY._secret = toString keyFile;
          APP_FORCE_HTTPS = false;
          APP_URL = "http://${freescoutDomain}";
          APP_REMOTE_HOST_WHITE_LIST = "localhost,127.0.0.1,::1";
          APP_DEBUG = true;
        };
      };
    };

  mkNode =
    dbType:
    { config, pkgs, ... }:
    {
      imports = [
        baseTestNode
      ];
      services.freescout.databaseSetup = {
        enable = true;
        kind = dbType;
      };
    };
in
{
  name = "freescout-integration";
  meta.maintainers = with lib.maintainers; [
    e1mo
  ];

  nodes = {
    # This may lead to duplicate tests, but ensures that
    # it's always tested on the current default version
    # even if the tests are not updated
    freescout_pgsql = mkNode "pgsql";

    # Same as the freescout_pgsql_default node
    freescout_mysql = mkNode "mysql";
  };

  testScript = ''
    start_all()

    for machine in [freescout_pgsql]:
      machine.wait_for_unit("postgresql")

    for machine in [freescout_mysql]:
      machine.wait_for_unit("mysql")

    all=[
      freescout_pgsql,
      freescout_mysql
    ]

    for machine in all:
      machine.wait_for_unit("nginx")
      machine.wait_for_unit("dovecot")
      machine.wait_for_unit("mailhog")
      machine.wait_for_open_port(1025)
      machine.wait_for_open_port(8025)
      machine.wait_for_unit("freescout-setup")

      with subtest("Login works"):
        machine.succeed("/var/lib/freescout/artisan freescout:create-user --role=admin --firstName=Xenia --lastName=TheFox --email xenia@${freescoutDomain} --no-interaction --password=foo | grep 'User created with id'")
        token=machine.succeed("curl -fsSL --cookie-jar cjar 'http://${freescoutDomain}/login' | grep -Po '(?<= name=\"_token\" value=\")(\\w+)(?=\")'").strip()
        data=f"email=xenia%40${freescoutDomain}&password=foo&_token={token}&remember=on"
        machine.succeed(f"curl -sSfX POST --cookie-jar cjar --cookie cjar --data-raw '{data}' 'http://${freescoutDomain}/login' | grep 'Redirecting to'")
        machine.succeed("curl -fsSL --cookie-jar cjar --cookie cjar 'http://${freescoutDomain}' | grep 'Dashboard'")
        # Enable all (most except following) notifications
        to_enable=list(range(1, 9))
        enable_data="&".join(map(lambda n: "subscriptions%5B1%5D%5B%5D=" + str(n), range(1,9)))
        data=f"_token={token}&{enable_data}"
        machine.succeed(f"curl -sSfX POST --cookie-jar cjar --cookie cjar --data-raw '{data}' 'http://${freescoutDomain}/users/notifications/1'")

      with subtest("Create and edit Mailbox"):
        data=f"email=freescout%40${mailDomain}&name=Test+Mailbox&_token={token}"
        machine.succeed(f"curl -sSfX POST --cookie-jar cjar --cookie cjar --data-raw '{data}' 'http://${freescoutDomain}/mailbox/new'")
        machine.succeed("curl -fsSL --cookie-jar cjar --cookie cjar 'http://${freescoutDomain}' | grep 'Test Mailbox'")
        machine.succeed("curl -sSf --cookie-jar cjar --cookie cjar 'http://${freescoutDomain}/mailbox/1' | grep 'freescout@${mailDomain}'")
        data=f"out_method=3&out_server=localhost&out_port=1025&out_username=&out_password=&out_encryption=1&_token={token}"
        machine.succeed(f"curl -sSfX POST --cookie-jar cjar --cookie cjar --data-raw '{data}' 'http://${freescoutDomain}/mailbox/connection-settings/1/outgoing'")
        data=f"&in_protocol=1&in_server=localhost&in_port=143&in_username=freescout&in_password=super_secret&in_encryption=1&in_imap_folders%5B%5D=INBOX&imap_sent_folder=&_token={token}"
        machine.succeed(f"curl -fsSX POST --cookie-jar cjar --cookie cjar --data-raw '{data}' 'http://${freescoutDomain}/mailbox/connection-settings/1/incoming'")
        data="&action=fetch_test&mailbox_id=1"
        machine.succeed(f"test $(curl -sSfX POST --cookie-jar cjar --cookie cjar -H 'X-CSRF-TOKEN: {token}' --data-raw '{data}' 'http://${freescoutDomain}/mailbox/ajax' | jq -r '.status') = 'success'")

      with subtest("Send E-Mails"):
        machine.succeed("send-initial")

    # Doing a second loop so that we won't have to wait that much
    for machine in all:
      with subtest("E-Mails ae received"):
        machine.wait_until_succeeds("curl -sSf --cookie-jar cjar --cookie cjar 'http://${freescoutDomain}/mailbox/1' | grep 'Hello NixOS'", timeout=180)
        # Notifactions to users are being sent

    for machine in all:
      with subtest("Notifications are sent"):
        machine.wait_until_succeeds("test $(curl -sSf http://127.0.0.1:8025/api/v2/messages | jq '.total') -eq 1", timeout=180)
        machine.succeed("curl -sSf http://127.0.0.1:8025/api/v2/messages | jq '.items[].Content.Headers[\"X-FreeScout-Mail-Type\"] | .[0]'")

      with subtest("Ensure vars are being generated"):
        machine.succeed("curl -sSf 'http://${freescoutDomain}/'")
        machine.succeed("curl -sSf 'http://${freescoutDomain}/storage/js/vars.js'")
  '';
}
