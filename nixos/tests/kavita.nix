import ./make-test-python.nix ({ pkgs, ...} : {
  name = "kavita";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ misterio77 ];
  };

  nodes = {
    kavita = { config, pkgs, ... }: {
      services.kavita = {
        enable = true;
        port = 5000;
        tokenKeyFile = builtins.toFile "kavita.key" "QfpjFvjT83BLtZ74GE3U3Q==";
      };
    };
  };

  testScript = let
    regUrl = "http://kavita:5000/api/Account/register";
    payload = builtins.toFile "payload.json" (builtins.toJSON {
      username = "foo";
      password = "correcthorsebatterystaple";
      email = "foo@bar";
    });
  in ''
    kavita.start
    kavita.wait_for_unit("kavita.service")

    # Check that static assets are working
    kavita.wait_until_succeeds("curl http://kavita:5000/site.webmanifest | grep Kavita")

    # Check that registration is working
    kavita.succeed("curl -fX POST ${regUrl} --json @${payload}")
    # But only for the first one
    kavita.fail("curl -fX POST ${regUrl} --json @${payload}")
  '';
})
