# This tests parsedmarc by sending a report to its monitored email
# address and reading the results out of Elasticsearch.

{ pkgs, ... }@args:
let
  inherit (import ../../lib/testing-python.nix args) makeTest;
  inherit (pkgs) lib;

  dmarcTestReport = builtins.fetchurl {
    name = "dmarc-test-report";
    url = "https://github.com/domainaware/parsedmarc/raw/f45ab94e0608088e0433557608d9f4e9517d3afe/samples/aggregate/estadocuenta1.infonacot.gob.mx!example.com!1536853302!1536939702!2940.xml.zip";
    sha256 = "0dq64cj49711kbja27pjl2hy0d3azrjxg91kqrh40x46fkn1dwkx";
  };

  sendEmail =
    address:
    pkgs.writeScriptBin "send-email" ''
      #!${pkgs.python3.interpreter}
      import smtplib
      from email import encoders
      from email.mime.base import MIMEBase
      from email.mime.multipart import MIMEMultipart
      from email.mime.text import MIMEText

      sender_email = "dmarc_tester@fake.domain"
      receiver_email = "${address}"

      message = MIMEMultipart()
      message["From"] = sender_email
      message["To"] = receiver_email
      message["Subject"] = "DMARC test"

      message.attach(MIMEText("Testing parsedmarc", "plain"))

      attachment = MIMEBase("application", "zip")

      with open("${dmarcTestReport}", "rb") as report:
          attachment.set_payload(report.read())

      encoders.encode_base64(attachment)

      attachment.add_header(
          "Content-Disposition",
          "attachment; filename= estadocuenta1.infonacot.gob.mx!example.com!1536853302!1536939702!2940.xml.zip",
      )

      message.attach(attachment)
      text = message.as_string()

      with smtplib.SMTP('localhost') as server:
          server.sendmail(sender_email, receiver_email, text)
          server.quit()
    '';
in
{
  localMail = makeTest {
    name = "parsedmarc-local-mail";
    meta = with lib.maintainers; {
      maintainers = [ talyz ];
    };

    nodes.parsedmarc =
      { nodes, ... }:
      {
        virtualisation.memorySize = 2048;

        services.postfix = {
          enableSubmission = true;
          enableSubmissions = true;
          submissionsOptions = {
            smtpd_sasl_auth_enable = "yes";
            smtpd_client_restrictions = "permit";
          };
        };

        services.parsedmarc = {
          enable = true;
          provision = {
            geoIp = false;
            localMail = {
              enable = true;
              hostname = "localhost";
            };
          };
        };

        environment.systemPackages = [
          (sendEmail "dmarc@localhost")
          pkgs.jq
        ];
      };

    testScript =
      { nodes }:
      let
        esPort = toString nodes.parsedmarc.config.services.elasticsearch.port;
        valueObject = lib.optionalString (lib.versionAtLeast nodes.parsedmarc.config.services.elasticsearch.package.version "7") ".value";
      in
      ''
        parsedmarc.start()
        parsedmarc.wait_for_unit("postfix.service")
        parsedmarc.wait_for_unit("dovecot2.service")
        parsedmarc.wait_for_unit("parsedmarc.service")
        parsedmarc.wait_until_succeeds(
            "curl -sS -f http://localhost:${esPort}"
        )

        parsedmarc.fail(
            "curl -sS -f http://localhost:${esPort}/_search?q=report_id:2940"
            + " | tee /dev/console"
            + " | jq -es 'if . == [] then null else .[] | .hits.total${valueObject} > 0 end'"
        )
        parsedmarc.succeed("send-email")
        parsedmarc.wait_until_succeeds(
            "curl -sS -f http://localhost:${esPort}/_search?q=report_id:2940"
            + " | tee /dev/console"
            + " | jq -es 'if . == [] then null else .[] | .hits.total${valueObject} > 0 end'"
        )
      '';
  };

  externalMail =
    let
      certs = import ../common/acme/server/snakeoil-certs.nix;
      mailDomain = certs.domain;
      parsedmarcDomain = "parsedmarc.fake.domain";
    in
    makeTest {
      name = "parsedmarc-external-mail";
      meta = with lib.maintainers; {
        maintainers = [ talyz ];
      };

      nodes = {
        parsedmarc =
          { nodes, ... }:
          {
            virtualisation.memorySize = 2048;

            security.pki.certificateFiles = [
              certs.ca.cert
            ];

            networking.extraHosts = ''
              127.0.0.1 ${parsedmarcDomain}
              ${nodes.mail.config.networking.primaryIPAddress} ${mailDomain}
            '';

            services.parsedmarc = {
              enable = true;
              provision.geoIp = false;
              settings.imap = {
                host = mailDomain;
                port = 993;
                ssl = true;
                user = "alice";
                password = "${pkgs.writeText "imap-password" "foobar"}";
              };
            };

            environment.systemPackages = [
              pkgs.jq
            ];
          };

        mail =
          { nodes, ... }:
          {
            imports = [ ../common/user-account.nix ];

            networking.extraHosts = ''
              127.0.0.1 ${mailDomain}
              ${nodes.parsedmarc.config.networking.primaryIPAddress} ${parsedmarcDomain}
            '';

            services.dovecot2 = {
              enable = true;
              protocols = [ "imap" ];
              sslCACert = "${certs.ca.cert}";
              sslServerCert = "${certs.${mailDomain}.cert}";
              sslServerKey = "${certs.${mailDomain}.key}";
            };

            services.postfix = {
              enable = true;
              origin = mailDomain;
              settings.main = {
                myhostname = mailDomain;
                mydestination = mailDomain;
              };
              enableSubmission = true;
              enableSubmissions = true;
              submissionsOptions = {
                smtpd_sasl_auth_enable = "yes";
                smtpd_client_restrictions = "permit";
              };
            };
            environment.systemPackages = [ (sendEmail "alice@${mailDomain}") ];

            networking.firewall.allowedTCPPorts = [ 993 ];
          };
      };

      testScript =
        { nodes }:
        let
          esPort = toString nodes.parsedmarc.config.services.elasticsearch.port;
          valueObject = lib.optionalString (lib.versionAtLeast nodes.parsedmarc.config.services.elasticsearch.package.version "7") ".value";
        in
        ''
          mail.start()
          mail.wait_for_unit("postfix.service")
          mail.wait_for_unit("dovecot2.service")

          parsedmarc.start()
          parsedmarc.wait_for_unit("parsedmarc.service")
          parsedmarc.wait_until_succeeds(
              "curl -sS -f http://localhost:${esPort}"
          )

          parsedmarc.fail(
              "curl -sS -f http://localhost:${esPort}/_search?q=report_id:2940"
              + " | tee /dev/console"
              + " | jq -es 'if . == [] then null else .[] | .hits.total${valueObject} > 0 end'"
          )
          mail.succeed("send-email")
          parsedmarc.wait_until_succeeds(
              "curl -sS -f http://localhost:${esPort}/_search?q=report_id:2940"
              + " | tee /dev/console"
              + " | jq -es 'if . == [] then null else .[] | .hits.total${valueObject} > 0 end'"
          )
        '';
    };
}
