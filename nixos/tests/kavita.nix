{ pkgs, ... }:
let
  emailTemplDir = "/var/lib/kavita/EmailTemplates";
in
{
  name = "kavita";
  meta = with pkgs.kavita; {
    inherit (meta) maintainers;
  };

  nodes =
    let
      key = "d26ba694b455271a8872415830fb7b5c58f8da98f9ef7f58b2ca4c34bd406512";
    in
    {
      kavita = {
        services.kavita = {
          enable = true;
          settings.TokenKey = key;
        };
      };
      has_template =
        { config, ... }:
        let
          u = config.services.kavita.user;
        in
        {
          services.kavita = {
            enable = true;
            settings.TokenKey = key;
          };
          systemd.tmpfiles.rules = [
            "d ${emailTemplDir} 0750 ${u} ${u} - -"
            "f ${emailTemplDir}/EmailTest.html 0750 ${u} ${u} - <tr><p>{{email.email-test.description}}</p></tr>"
          ];
        };
    };

  testScript =
    let
      regUrl = "http://kavita:5000/api/Account/register";
      loginUrl = "http://kavita:5000/api/Account/login";
      localeUrl = "http://kavita:5000/api/locale";
      fileCountCommand = "ls ${emailTemplDir} | wc -l";
    in
    ''
      import json

      kavita.wait_for_unit("kavita.service")
      has_template.wait_for_unit("kavita.service")

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

      with subtest("`${emailTemplDir}` should be prepopulated with upstream email templates"):
          files = int(kavita.succeed("${fileCountCommand}").strip())
          t.assertTrue(files > 1, "`${emailTemplDir}` does not contain more than 1 file [actual: %f]" % (files))

      with subtest("server with e-mail templates in `${emailTemplDir}` should not be overwritten"):
          files = int(has_template.succeed("${fileCountCommand}").strip())
          t.assertEqual(1, files, "`${emailTemplDir}` does not contain exactly 1 file [actual: %f]" % (files))
    '';
}
