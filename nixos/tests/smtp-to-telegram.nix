import ./make-test-python.nix ({ pkgs, ... }: {
  name = "smtp-to-telegram";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ patryk27 ];
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = let
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

      in [ sendTestMail ];

    services.nginx = {
      enable = true;

      virtualHosts.localhost = {
        listen = [{
          addr = "127.0.0.1";
          port = 8080;
        }];

        locations."/bot123:cafebabe/sendMessage" = {
          return = "200 ''";
        };
      };
    };

    services.smtp-to-telegram = {
      enable = true;
      telegramApiPrefix = "http://127.0.0.1:8080/";
      telegramChatIds = [ "1234" ];
      telegramBotToken = "123:cafebabe";
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
