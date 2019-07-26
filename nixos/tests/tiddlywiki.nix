import ./make-test.nix ({ ... }: {
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
          credentials="../wikiusers.csv";
          readers="(authenticated)";
        };
      };
    };
  };

  testScript = ''
    startAll;

    subtest "by default works without configuration", sub {
      $default->waitForUnit("tiddlywiki.service");
    };

    subtest "by default available on port 8080 without auth", sub {
      $default->waitForUnit("tiddlywiki.service");
      $default->waitForOpenPort(8080);
      $default->succeed("curl --fail 127.0.0.1:8080");
    };

    subtest "by default creates empty wiki", sub {
      $default->succeed("test -f /var/lib/tiddlywiki/tiddlywiki.info");
    };

    subtest "configured on port 3000 with basic auth", sub {
      $configured->waitForUnit("tiddlywiki.service");
      $configured->waitForOpenPort(3000);
      $configured->fail("curl --fail 127.0.0.1:3000");
      $configured->succeed("curl --fail 127.0.0.1:3000 --user somelogin:somesecret");
    };

    subtest "configured with different wikifolder", sub {
      $configured->succeed("test -f /var/lib/tiddlywiki/tiddlywiki.info");
    };

    subtest "restart preserves changes", sub {
      # given running wiki
      $default->waitForUnit("tiddlywiki.service");
      # with some changes
      $default->succeed("curl --fail --request PUT --header 'X-Requested-With:TiddlyWiki' --data '{ \"title\": \"title\", \"text\": \"content\" }' --url 127.0.0.1:8080/recipes/default/tiddlers/somepage ");
      $default->succeed("sleep 2"); # server syncs to filesystem on timer

      # when wiki is cycled
      $default->systemctl("restart tiddlywiki.service");
      $default->waitForUnit("tiddlywiki.service");
      $default->waitForOpenPort(8080);

      # the change is preserved
      $default->succeed("curl --fail 127.0.0.1:8080/recipes/default/tiddlers/somepage");
    };
  '';
})
