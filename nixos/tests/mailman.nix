{ ... }:
{
  name = "mailman";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ mailutils ];

      services.mailman.enable = true;
      services.mailman.serve.enable = true;
      services.mailman.siteOwner = "postmaster@example.com";
      services.mailman.webHosts = [ "example.com" ];

      services.postfix.enable = true;
      services.postfix.settings.main = {
        mydestination = [
          "example.com"
          "example.net"
        ];
        relay_domains = [ "hash:/var/lib/mailman/data/postfix_domains" ];
        local_recipient_maps = [
          "hash:/var/lib/mailman/data/postfix_lmtp"
          "proxy:unix:passwd.byname"
        ];
        transport_maps = [ "hash:/var/lib/mailman/data/postfix_lmtp" ];
      };

      users.users.user = {
        isNormalUser = true;
      };

      virtualisation.memorySize = 2048;

      specialisation.restApiPassFileSystem.configuration = {
        services.mailman.restApiPassFile = "/var/lib/mailman/pass";
      };
    };

  testScript =
    { nodes, ... }:
    let
      restApiPassFileSystem = "${nodes.machine.system.build.toplevel}/specialisation/restApiPassFileSystem";
    in
    ''
      def check_mail(_) -> bool:
          status, _ = machine.execute("grep -q hello /var/spool/mail/user/new/*")
          return status == 0

      def try_api(_) -> bool:
          status, _ = machine.execute("curl -s http://localhost:8001/")
          return status == 0

      def wait_for_api():
          with machine.nested("waiting for Mailman REST API to be available"):
              retry(try_api)

      machine.wait_for_unit("mailman.service")
      wait_for_api()

      with subtest("subscription and delivery"):
          creds = machine.succeed("su -s /bin/sh -c 'mailman info' mailman | grep '^REST credentials: ' | sed 's/^REST credentials: //'").strip()
          machine.succeed(f"curl --fail-with-body -sLSu {creds} -d mail_host=example.com http://localhost:8001/3.1/domains")
          machine.succeed(f"curl --fail-with-body -sLSu {creds} -d fqdn_listname=list@example.com http://localhost:8001/3.1/lists")
          machine.succeed(f"curl --fail-with-body -sLSu {creds} -d list_id=list.example.com -d subscriber=root@example.com -d pre_confirmed=True -d pre_verified=True -d send_welcome_message=False http://localhost:8001/3.1/members")
          machine.succeed(f"curl --fail-with-body -sLSu {creds} -d list_id=list.example.com -d subscriber=user@example.net -d pre_confirmed=True -d pre_verified=True -d send_welcome_message=False http://localhost:8001/3.1/members")
          machine.succeed("mail -a 'From: root@example.com' -s hello list@example.com < /dev/null")
          with machine.nested("waiting for mail from list"):
              retry(check_mail)

      with subtest("Postorius"):
          machine.succeed("curl --fail-with-body -sILS http://localhost/")

      with subtest("restApiPassFile"):
          machine.succeed("echo secretpassword > /var/lib/mailman/pass")
          machine.succeed("${restApiPassFileSystem}/bin/switch-to-configuration test >&2")
          machine.succeed("grep secretpassword /etc/mailman.cfg")
          machine.succeed("su -s /bin/sh -c 'mailman info' mailman | grep secretpassword")
          wait_for_api()
          machine.succeed("curl --fail-with-body -sLSu restadmin:secretpassword http://localhost:8001/3.1/domains")
          machine.succeed("curl --fail-with-body -sILS http://localhost/")

      with subtest("service locking"):
          machine.fail("su -s /bin/sh -c 'mailman start' mailman")
          machine.execute("systemctl kill --signal=SIGKILL mailman")
          machine.succeed("systemctl restart mailman")
          wait_for_api()
    '';
}
