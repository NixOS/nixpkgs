import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "smtp-to-telegram";

  meta = with lib.maintainers; {
    maintainers = [ patryk27 ];
  };

  nodes = {
    machine = { pkgs, ... }: {
      environment.systemPackages =
        let
          sendTestMail = pkgs.writeScriptBin "send-test-mail" ''
            #!${pkgs.python3.interpreter}
            import smtplib, sys

            with smtplib.SMTP('127.0.0.1:2525') as smtp:
              smtp.sendmail('root@localhost', 'root@localhost', """
                From: root@localhost
                To: root@localhost
                Subject: Test

                Hello, World!
              """)
          '';

        in
        [ sendTestMail ];

      services.nginx = {
        enable = true;

        virtualHosts.localhost = {
          listen = [{
            addr = "127.0.0.1";
            port = 8080;
          }];

          locations."/bot123:cafebabe/sendMessage" = {
            return = "200 '{ \"ok\": true }'";
          };
        };
      };

      services.smtp-to-telegram = {
        enable = true;
        telegramApiPrefix = "http://127.0.0.1:8080/";
        telegramChatIds = [ "1234" ];

        telegramBotTokenFile = toString (pkgs.writeText "secret-token.txt" ''
          123:cafebabe
        '');
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("nginx")
    machine.wait_for_unit("smtp-to-telegram")
    machine.succeed("send-test-mail")
    machine.succeed("grep sendMessage /var/log/nginx/access.log")
  '';
})
