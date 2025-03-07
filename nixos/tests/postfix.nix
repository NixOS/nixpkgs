let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
import ./make-test-python.nix {
  name = "postfix";

  nodes.machine = { pkgs, ... }: {
    imports = [ common/user-account.nix ];
    services.postfix = {
      enable = true;
      enableSubmission = true;
      enableSubmissions = true;
      tlsTrustedAuthorities = "${certs.ca.cert}";
      sslCert = "${certs.${domain}.cert}";
      sslKey = "${certs.${domain}.key}";
      submissionsOptions = {
          smtpd_sasl_auth_enable = "yes";
          smtpd_client_restrictions = "permit";
          milter_macro_daemon_name = "ORIGINATING";
      };
    };

    security.pki.certificateFiles = [
      certs.ca.cert
    ];

    networking.extraHosts = ''
      127.0.0.1 ${domain}
    '';

    environment.systemPackages = let
      sendTestMail = pkgs.writeScriptBin "send-testmail" ''
        #!${pkgs.python3.interpreter}
        import smtplib

        with smtplib.SMTP('${domain}') as smtp:
          smtp.sendmail('root@localhost', 'alice@localhost', 'Subject: Test\n\nTest data.')
          smtp.quit()
      '';

      sendTestMailStarttls = pkgs.writeScriptBin "send-testmail-starttls" ''
        #!${pkgs.python3.interpreter}
        import smtplib
        import ssl

        ctx = ssl.create_default_context()

        with smtplib.SMTP('${domain}') as smtp:
          smtp.ehlo()
          smtp.starttls(context=ctx)
          smtp.ehlo()
          smtp.sendmail('root@localhost', 'alice@localhost', 'Subject: Test STARTTLS\n\nTest data.')
          smtp.quit()
      '';

      sendTestMailSmtps = pkgs.writeScriptBin "send-testmail-smtps" ''
        #!${pkgs.python3.interpreter}
        import smtplib
        import ssl

        ctx = ssl.create_default_context()

        with smtplib.SMTP_SSL(host='${domain}', context=ctx) as smtp:
          smtp.sendmail('root@localhost', 'alice@localhost', 'Subject: Test SMTPS\n\nTest data.')
          smtp.quit()
      '';
    in [ sendTestMail sendTestMailStarttls sendTestMailSmtps ];
  };

  testScript = ''
    machine.wait_for_unit("postfix.service")
    machine.succeed("send-testmail")
    machine.succeed("send-testmail-starttls")
    machine.succeed("send-testmail-smtps")
  '';
}
