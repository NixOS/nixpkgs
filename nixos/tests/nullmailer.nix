{ lib, ... }:
{
  name = "nullmailer";

  meta = {
    maintainers = with lib.maintainers; [ h7x4 ];
  };

  nodes = {
    mail =
      { config, ... }:
      {
        imports = [ ./common/user-account.nix ];

        virtualisation.vlans = [ 1 ];

        networking = {
          useNetworkd = true;
          useDHCP = false;
          firewall.allowedTCPPorts = [ 25 ];
          domain = "example.com";
          hosts."10.0.0.2" = [ "machine.example.com" ];
        };

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.1/24";
        };

        services.postfix = {
          enable = true;

          localRecipients = [ "alice" ];

          settings = {
            main = {
              myhostname = config.networking.hostName;
              mydomain = config.networking.domain;
              mynetworks = [ "0.0.0.0/0" ];
              mydestination = [ "$mydomain" ];

              smtpd_recipient_restrictions = "permit_mynetworks, reject";
            };
          };
        };
      };

    machine =
      { config, ... }:
      {
        virtualisation.vlans = [ 1 ];

        networking = {
          useNetworkd = true;
          useDHCP = false;
          domain = "example.com";
          hosts."10.0.0.1" = [ "mail.example.com" ];
        };

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.2/24";
        };

        services.nullmailer = {
          enable = true;
          config = {
            me = "${config.networking.fqdn}";
            remotes = "mail.example.com smtp --port=25";
          };
        };
      };
  };

  testScript = ''
    start_all()

    machine.wait_for_open_port(25, "mail.example.com")
    machine.wait_for_unit("nullmailer.service")
    machine.succeed('printf "To: alice@example.com\r\n\r\nthis is the body of the email" | sendmail -t -i -f sender@example.com')

    mail.wait_for_console_text("delivered to maildir")
    print(mail.succeed("grep 'this is the body of the email' /var/spool/mail/alice/new/*"))
  '';
}
