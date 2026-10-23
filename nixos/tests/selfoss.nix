{ pkgs, ... }:

let
  articleTitle = "Hello from the test feed";
in
{
  name = "selfoss";

  meta.maintainers = with pkgs.lib.maintainers; [ h7x4 ];

  containers.machine = {
    networking.hosts."127.0.0.1" = [
      "selfoss.local"
      "feed.local"
    ];

    services.selfoss = {
      enable = true;
      nginx = {
        enable = true;
        virtualHost = "selfoss.local";
      };
      settings = {
        username = "testuser";
        # bcrypt hash of "testpass", computed with:
        #   php -r 'echo password_hash("testpass", PASSWORD_BCRYPT);'
        password = "$2y$12$s/LJYwyDbWJWIyQuUEhyHekD9V3mTLZsdwpuWxtTOgO2BtHGu5vyi";
      };
    };

    services.nginx.virtualHosts."feed.local" =
      let
        url = "http://feed.local/";
      in
      {
        root = pkgs.writeTextDir "rss.xml" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <rss version="2.0">
            <channel>
              <title>Dummy feed</title>
              <link>${url}</link>
              <description>Dummy feed for testing</description>
              <item>
                <title>${articleTitle}</title>
                <link>${url}article.html</link>
                <guid>${url}article.html</guid>
                <description>The lazy fox jumps over the quick brown dog</description>
              </item>
            </channel>
          </rss>
        '';
      };
  };

  testScript = ''
    import json
    from typing import Any

    start_all()

    machine.wait_for_unit("phpfpm-selfoss_pool.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)

    # Otherwise the hourly timer can race with the manual update triggered below.
    machine.succeed("systemctl stop --now selfoss-update.timer")

    def api(path: str, curl_args: str = "") -> Any:
        return json.loads(
            machine.succeed(
                f"curl --silent --fail --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt"
                f" {curl_args} http://selfoss.local{path}"
            )
        )

    login = api("/login", "--data-urlencode 'username=testuser' --data-urlencode 'password=testpass'")
    assert login["success"]

    registration = api("/source", f"--json '{json.dumps({
        "title": "Test feed",
        "spout": "spouts_rss_feed",
        "url": "http://feed.local/rss.xml",
    })}'")
    assert registration["success"]

    machine.succeed("systemctl start selfoss-update.service")

    assert any(item["title"] == "${articleTitle}" for item in api("/items"))

    machine.fail("curl --silent --fail http://selfoss.local/config.ini")
  '';
}
