import ./make-test-python.nix ({ pkgs, ... }: {
  name = "kavita";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ misterio77 ];
  };

  nodes = {
    kavita = { config, pkgs, ... }: {
      services.kavita = {
        enable = true;
        tokenKeyFile = builtins.toFile "kavita.key" "d26ba694b455271a8872415830fb7b5c58f8da98f9ef7f58b2ca4c34bd406512";
      };
    };
  };

  testScript =
    let
      regUrl = "http://kavita:5000/api/Account/register";
      loginUrl = "http://kavita:5000/api/Account/login";
      localeUrl = "http://kavita:5000/api/locale";
    in
    ''
      import json

      kavita.start
      kavita.wait_for_unit("kavita.service")

      # Check that static assets are working
      kavita.wait_until_succeeds("curl http://kavita:5000/site.webmanifest | grep Kavita")

      # Check that registration is working
      kavita.succeed("""curl -fX POST ${regUrl} --json '{"username": "foo", "password": "correcthorsebatterystaple"}'""")
      # But only for the first one
      kavita.fail("""curl -fX POST ${regUrl} --json '{"username": "foo", "password": "correcthorsebatterystaple"}'""")

      # Log in and retrieve token
      session = json.loads(kavita.succeed("""curl -fX POST ${loginUrl} --json '{"username": "foo", "password": "correcthorsebatterystaple"}'"""))
      # Check list of locales
      locales = json.loads(kavita.succeed(f"curl -fX GET ${localeUrl} -H 'Authorization: Bearer {session['token']}'"))
      assert len(locales) > 0, "expected a list of locales"
    '';
})
