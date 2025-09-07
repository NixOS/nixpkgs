let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
import ./make-test-python.nix {
  name = "postfix";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ common/user-account.nix ];
      services.postfix = {
        enable = true;
        enableSubmission = true;
        enableSubmissions = true;
        settings.main = {
          smtp_tls_CAfile = "${certs.ca.cert}";
          smtpd_tls_chain_files = [
            certs.${domain}.key
            certs.${domain}.cert
          ];
        };
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

      environment.systemPackages =
        let
          sendTestMail = pkgs.writers.writePython3Bin "send-testmail" { } ''
            import smtplib

            with smtplib.SMTP('${domain}') as smtp:
                smtp.sendmail('root@localhost', 'alice@localhost',
                              'Subject: Test\n\nTest data.')
                smtp.quit()
          '';

          sendTestMailStarttls = pkgs.writers.writePython3Bin "send-testmail-starttls" { } ''
            import smtplib
            import ssl

            ctx = ssl.create_default_context()

            with smtplib.SMTP('${domain}') as smtp:
                smtp.ehlo()
                smtp.starttls(context=ctx)
                smtp.ehlo()
                smtp.sendmail('root@localhost', 'alice@localhost',
                              'Subject: Test STARTTLS\n\nTest data.')
                smtp.quit()
          '';

          sendTestMailSmtps = pkgs.writers.writePython3Bin "send-testmail-smtps" { } ''
            import smtplib
            import ssl

            ctx = ssl.create_default_context()

            with smtplib.SMTP_SSL(host='${domain}', context=ctx) as smtp:
                smtp.sendmail('root@localhost', 'alice@localhost',
                              'Subject: Test SMTPS\n\nTest data.')
                smtp.quit()
          '';
        in
        [
          sendTestMail
          sendTestMailStarttls
          sendTestMailSmtps
        ];
    };

  testScript = ''
    machine.wait_for_unit("postfix.service")
    machine.succeed("send-testmail")
    machine.succeed("send-testmail-starttls")
    machine.succeed("send-testmail-smtps")
  '';
}
