{ lib, ... }:
let
  feedPort = 8080;
in
{
  name = "freshrss-updater";
  meta.maintainers = with lib.maintainers; [
    stunkymonkey
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.freshrss = {
        enable = true;
        baseUrl = "http://localhost";
        passwordFile = pkgs.writeText "password" "secret";
        internalHostAllowlist = [ "127.0.0.1:${toString feedPort}" ];
      };

      # Serve a feed from the local host, which FreshRSS blocks unless allowlisted.
      services.nginx.virtualHosts.feed = {
        listen = [
          {
            addr = "127.0.0.1";
            port = feedPort;
          }
        ];
        root = pkgs.writeTextDir "feed.xml" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <rss version="2.0">
            <channel>
              <title>Test feed</title>
              <link>http://127.0.0.1:${toString feedPort}/</link>
              <description>Test feed</description>
              <item>
                <title>Hello from the test feed</title>
                <link>http://127.0.0.1:${toString feedPort}/hello</link>
                <guid>hello</guid>
                <description>Hello</description>
              </item>
            </channel>
          </rss>
        '';
      };

      environment.etc."freshrss-test.opml".text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
          <head><title>Test</title></head>
          <body>
            <outline text="Test feed" type="rss" xmlUrl="http://127.0.0.1:${toString feedPort}/feed.xml"/>
          </body>
        </opml>
      '';

      environment.systemPackages = [ pkgs.sqlite ];
    };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.freshrss;
      db = "${cfg.dataDir}/users/${cfg.defaultUser}/db.sqlite";
    in
    ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("freshrss-config.service")
      machine.wait_for_open_port(${toString feedPort})

      machine.succeed(
        "cd ${cfg.package} && sudo -u ${cfg.user} env DATA_PATH=${cfg.dataDir} "
        + "./cli/import-for-user.php --user ${cfg.defaultUser} --filename /etc/freshrss-test.opml"
      )
      # The import already refreshes the feed; force the updater to fetch it again.
      machine.succeed("sqlite3 ${db} 'DELETE FROM entry; UPDATE feed SET lastUpdate = 0'")

      machine.succeed("systemctl start freshrss-updater.service")

      machine.succeed(
        "sqlite3 ${db} \"SELECT title FROM entry\" | grep 'Hello from the test feed'"
      )
    '';
}
