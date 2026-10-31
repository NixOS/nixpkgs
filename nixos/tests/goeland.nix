{ pkgs, ... }:
let
  articleTitle = "Hello from the test feed";

  # goeland refuses to fetch local and private IPs:
  # https://github.com/slurdge/goeland/blob/3eb263bcb2c6617c74326f629efa9075f1f40783/internal/goeland/httpget/httpget.go#L75-L77
  feedAddress = "203.0.113.1";
  machineAddress = "203.0.113.2";
in
{
  name = "goeland";
  meta.maintainers = with pkgs.lib.maintainers; [ h7x4 ];

  containers = {
    feed = {
      networking = {
        useNetworkd = true;
        useDHCP = false;
        useHostResolvConf = false;
        firewall.allowedTCPPorts = [ 80 ];
      };
      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "${feedAddress}/24";
      };

      services.nginx = {
        enable = true;
        virtualHosts."feed.local".root = pkgs.writeTextDir "rss.xml" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <rss version="2.0">
            <channel>
              <title>Dummy feed</title>
              <link>http://feed.local/</link>
              <description>Dummy feed for testing</description>
              <item>
                <title>${articleTitle}</title>
                <link>http://feed.local/article.html</link>
                <guid>http://feed.local/article.html</guid>
                <description>The lazy fox jumps over the quick brown dog</description>
              </item>
            </channel>
          </rss>
        '';
      };
    };

    machine =
      { config, ... }:
      {
        imports = [ ./common/user-account.nix ];

        networking = {
          useNetworkd = true;
          useDHCP = false;
          useHostResolvConf = false;
          domain = "example.com";
          hosts.${feedAddress} = [ "feed.local" ];
        };
        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "${machineAddress}/24";
        };

        services.postfix = {
          enable = true;
          settings.main.mydestination = [ config.networking.domain ];
        };

        services.goeland = {
          enable = true;
          settings = {
            loglevel = "trace";
            email = {
              host = "127.0.0.1";
              port = 25;
              authentication = "none";
              encryption = "none";
            };
            sources.feed = {
              type = "feed";
              url = "http://feed.local/rss.xml";
              allow-insecure = true;
              filters = [ "all" ];
            };
            pipes.feed = {
              source = "feed";
              destination = "email";
              email_from = "goeland@example.com";
              email_to = [ "alice@${config.networking.domain}" ];
            };
          };
        };
      };
  };

  testScript = ''
    start_all()

    feed.wait_for_open_port(80)
    machine.wait_for_unit("postfix.service")
    machine.systemctl("start goeland.service")

    machine.wait_until_succeeds("grep -qr '${articleTitle}' /var/spool/mail/alice/")
  '';
}
