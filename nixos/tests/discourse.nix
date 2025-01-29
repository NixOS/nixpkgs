# This tests Discourse by:
#  1. logging in as the admin user
#  2. sending a private message to the admin user through the API
#  3. replying to that message via email.

import ./make-test-python.nix (
  { pkgs, lib, package ? pkgs.discourse, ... }:
  let
    certs = import ./common/acme/server/snakeoil-certs.nix;
    clientDomain = "client.fake.domain";
    discourseDomain = certs.domain;
    adminPassword = "eYAX85qmMJ5GZIHLaXGDAoszD7HSZp5d";
    secretKeyBase = "381f4ac6d8f5e49d804dae72aa9c046431d2f34c656a705c41cd52fed9b4f6f76f51549f0b55db3b8b0dded7a00d6a381ebe9a4367d2d44f5e743af6628b4d42";
    admin = {
      email = "alice@${clientDomain}";
      username = "alice";
      fullName = "Alice Admin";
      passwordFile = "${pkgs.writeText "admin-pass" adminPassword}";
    };
  in
  {
    name = "discourse";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ talyz ];
    };

    nodes.discourse =
      { nodes, ... }:
      {
        virtualisation.memorySize = 2048;
        virtualisation.cores = 4;
        virtualisation.useNixStoreImage = true;
        virtualisation.writableStore = false;

        imports = [ common/user-account.nix ];

        security.pki.certificateFiles = [
          certs.ca.cert
        ];

        networking.extraHosts = ''
          127.0.0.1 ${discourseDomain}
          ${nodes.client.networking.primaryIPAddress} ${clientDomain}
        '';

        services.postfix = {
          enableSubmission = true;
          enableSubmissions = true;
          submissionsOptions = {
            smtpd_sasl_auth_enable = "yes";
            smtpd_client_restrictions = "permit";
          };
        };

        environment.systemPackages = [ pkgs.jq ];

        services.postgresql.package = pkgs.postgresql_13;

        services.discourse = {
          enable = true;
          inherit admin package;
          hostname = discourseDomain;
          sslCertificate = "${certs.${discourseDomain}.cert}";
          sslCertificateKey = "${certs.${discourseDomain}.key}";
          secretKeyBaseFile = "${pkgs.writeText "secret-key-base" secretKeyBase}";
          enableACME = false;
          mail.outgoing.serverAddress = clientDomain;
          mail.incoming.enable = true;
          siteSettings = {
            posting = {
              min_post_length = 5;
              min_first_post_length = 5;
              min_personal_message_post_length = 5;
            };
          };
          unicornTimeout = 900;
        };

        networking.firewall.allowedTCPPorts = [ 25 465 ];
      };

    nodes.client =
      { nodes, ... }:
      {
        imports = [ common/user-account.nix ];

        security.pki.certificateFiles = [
          certs.ca.cert
        ];

        networking.extraHosts = ''
          127.0.0.1 ${clientDomain}
          ${nodes.discourse.networking.primaryIPAddress} ${discourseDomain}
        '';

        services.dovecot2 = {
          enable = true;
          protocols = [ "imap" ];
          modules = [ pkgs.dovecot_pigeonhole ];
        };

        services.postfix = {
          enable = true;
          origin = clientDomain;
          relayDomains = [ clientDomain ];
          config = {
            compatibility_level = "2";
            smtpd_banner = "ESMTP server";
            myhostname = clientDomain;
            mydestination = clientDomain;
          };
        };

        environment.systemPackages =
          let
            replyToEmail = pkgs.writeScriptBin "reply-to-email" ''
              #!${pkgs.python3.interpreter}
              import imaplib
              import smtplib
              import ssl
              import email.header
              from email import message_from_bytes
              from email.message import EmailMessage

              with imaplib.IMAP4('localhost') as imap:
                  imap.login('alice', 'foobar')
                  imap.select()
                  status, data = imap.search(None, 'ALL')
                  assert status == 'OK'

                  nums = data[0].split()
                  assert len(nums) == 1

                  status, msg_data = imap.fetch(nums[0], '(RFC822)')
                  assert status == 'OK'

              msg = email.message_from_bytes(msg_data[0][1])
              subject = str(email.header.make_header(email.header.decode_header(msg['Subject'])))
              reply_to = email.header.decode_header(msg['Reply-To'])[0][0]
              message_id = email.header.decode_header(msg['Message-ID'])[0][0]
              date = email.header.decode_header(msg['Date'])[0][0]

              ctx = ssl.create_default_context()
              with smtplib.SMTP_SSL(host='${discourseDomain}', context=ctx) as smtp:
                  reply = EmailMessage()
                  reply['Subject'] = 'Re: ' + subject
                  reply['To'] = reply_to
                  reply['From'] = 'alice@${clientDomain}'
                  reply['In-Reply-To'] = message_id
                  reply['References'] = message_id
                  reply['Date'] = date
                  reply.set_content("Test reply.")

                  smtp.send_message(reply)
                  smtp.quit()
            '';
          in
            [ replyToEmail ];

        networking.firewall.allowedTCPPorts = [ 25 ];
      };


    testScript = { nodes }:
      let
        request = builtins.toJSON {
          title = "Private message";
          raw = "This is a test message.";
          target_recipients = admin.username;
          archetype = "private_message";
        };
      in ''
        discourse.start()
        client.start()

        discourse.wait_for_unit("discourse.service")
        discourse.wait_for_file("/run/discourse/sockets/unicorn.sock")
        discourse.wait_until_succeeds("curl -sS -f https://${discourseDomain}")
        discourse.succeed(
            "curl -sS -f https://${discourseDomain}/session/csrf -c cookie -b cookie -H 'Accept: application/json' | jq -r '\"X-CSRF-Token: \" + .csrf' > csrf_token",
            "curl -sS -f https://${discourseDomain}/session -c cookie -b cookie -H @csrf_token -H 'Accept: application/json' -d 'login=${nodes.discourse.services.discourse.admin.username}' -d \"password=${adminPassword}\" | jq -e '.user.username == \"${nodes.discourse.services.discourse.admin.username}\"'",
            "curl -sS -f https://${discourseDomain}/login -v -H 'Accept: application/json' -c cookie -b cookie 2>&1 | grep ${nodes.discourse.services.discourse.admin.username}",
        )

        client.wait_for_unit("postfix.service")
        client.wait_for_unit("dovecot2.service")

        discourse.succeed(
            "sudo -u discourse discourse-rake api_key:create_master[master] >api_key",
            'curl -sS -f https://${discourseDomain}/posts -X POST -H "Content-Type: application/json" -H "Api-Key: $(<api_key)" -H "Api-Username: system" -d \'${request}\' ',
        )

        client.wait_until_succeeds("reply-to-email")

        discourse.wait_until_succeeds(
            'curl -sS -f https://${discourseDomain}/topics/private-messages/system -H "Accept: application/json" -H "Api-Key: $(<api_key)" -H "Api-Username: system" | jq -e \'if .topic_list.topics[0].id != null then .topic_list.topics[0].id else null end\' >topic_id'
        )
        discourse.succeed(
            'curl -sS -f https://${discourseDomain}/t/$(<topic_id) -H "Accept: application/json" -H "Api-Key: $(<api_key)" -H "Api-Username: system" | jq -e \'if .post_stream.posts[1].cooked == "<p>Test reply.</p>" then true else null end\' '
        )
      '';
  })
