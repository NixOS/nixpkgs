{ pkgs, ... }:
{
  name = "simplelogin";

  nodes.server =
    { pkgs, ... }:
    {
      services.simplelogin = {
        enable = true;
        hostName = "sl.test";
        url = "http://sl.test";
        emailDomain = "example.test";
        supportEmail = "support@example.test";
        flaskSecret = "0123456789abcdef0123456789abcdef";
        dkimKeyFile = pkgs.writeText "dkim.key" ''
          dummy
        '';
        nginx.enable = false;
        mail.enable = false;
        jobRunner.enable = false;
        settings = {
          NOT_SEND_EMAIL = true;
          DISABLE_REGISTRATION = true;
          DISABLE_ONBOARDING = true;
        };
      };

      networking.extraHosts = ''
        127.0.0.1 sl.test
      '';
    };

  testScript = ''
    with subtest("web service starts"):
        server.wait_for_unit("simplelogin-web.service")
        server.wait_for_open_port(7777)

    with subtest("HTTP endpoint responds"):
        server.succeed("curl -sf http://sl.test:7777/")
  '';
}
