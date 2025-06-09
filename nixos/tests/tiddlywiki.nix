{ ... }:
{
  name = "tiddlywiki";
  nodes = {
    default = {
      services.tiddlywiki.enable = true;
    };
    configured = {
      boot.postBootCommands = ''
        echo "username,password
        somelogin,somesecret" > /var/lib/wikiusers.csv
      '';
      services.tiddlywiki = {
        enable = true;
        listenOptions = {
          port = 3000;
          credentials = "../wikiusers.csv";
          readers = "(authenticated)";
        };
      };
    };
  };

  testScript = ''
    start_all()

    with subtest("by default works without configuration"):
        default.wait_for_unit("tiddlywiki.service")

    with subtest("by default available on port 8080 without auth"):
        default.wait_for_unit("tiddlywiki.service")
        default.wait_for_open_port(8080)
        # we output to /dev/null here to avoid a python UTF-8 decode error
        # but the check will still fail if the service doesn't respond
        default.succeed("curl --fail -o /dev/null 127.0.0.1:8080")

    with subtest("by default creates empty wiki"):
        default.succeed("test -f /var/lib/tiddlywiki/tiddlywiki.info")

    with subtest("configured on port 3000 with basic auth"):
        configured.wait_for_unit("tiddlywiki.service")
        configured.wait_for_open_port(3000)
        configured.fail("curl --fail -o /dev/null 127.0.0.1:3000")
        configured.succeed(
            "curl --fail -o /dev/null 127.0.0.1:3000 --user somelogin:somesecret"
        )

    with subtest("restart preserves changes"):
        # given running wiki
        default.wait_for_unit("tiddlywiki.service")
        # with some changes
        default.succeed(
            'curl --fail --request PUT --header \'X-Requested-With:TiddlyWiki\' \
            --data \'{ "title": "title", "text": "content" }\' \
            --url 127.0.0.1:8080/recipes/default/tiddlers/somepage '
        )
        default.succeed("sleep 2")

        # when wiki is cycled
        default.systemctl("restart tiddlywiki.service")
        default.wait_for_unit("tiddlywiki.service")
        default.wait_for_open_port(8080)

        # the change is preserved
        default.succeed(
            "curl --fail -o /dev/null 127.0.0.1:8080/recipes/default/tiddlers/somepage"
        )
  '';
}
