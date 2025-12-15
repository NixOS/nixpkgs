{
  name,
  pkgs,
  testBase,
  system,
  ...
}:
with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest (
  { config, lib, ... }:
  let
    certs = import ../common/acme/server/snakeoil-certs.nix;
    domain = certs.domain;
  in
  {
    inherit name;

    meta.maintainers = lib.teams.nextcloud.members;

    imports = [ testBase ];

    nodes = {
      nextcloud =
        {
          config,
          pkgs,
          nodes,
          ...
        }:
        {
          security.pki.certificateFiles = [ certs.ca.cert ];

          networking.extraHosts = ''
            ${nodes.stalwart.networking.primaryIPAddress} ${domain}
          '';

          environment.etc."nextcloud/mail_smtppassword".text = "foobar";

          services.nextcloud = {
            config.dbtype = "sqlite";

            settings = {
              mail_from_address = "alice";
              mail_domain = domain;
              mail_smtpmode = "smtp";
              mail_smtphost = domain;
              mail_smtpport = 587;
              mail_smtpauth = true;
              mail_smtpname = "alice";
              mail_send_plaintext_only = true;
            };

            secrets.mail_smtppassword = "/etc/nextcloud/mail_smtppassword";
          };
        };

      stalwart =
        { pkgs, ... }:
        {
          imports = [ ../stalwart/stalwart-mail-config.nix ];

          networking.firewall.allowedTCPPorts = [ 587 ];

          environment.systemPackages = [
            (pkgs.writers.writePython3Bin "test-imap-read" { } ''
              from imaplib import IMAP4

              with IMAP4('localhost') as imap:
                  imap.starttls()
                  status, [caps] = imap.login('bob', 'foobar')
                  assert status == 'OK'
                  imap.select()
                  status, [ref] = imap.search(None, 'ALL')
                  assert status == 'OK'
                  [msgId] = ref.split()
                  status, msg = imap.fetch(msgId, 'BODY[TEXT]')
                  assert status == 'OK'
                  assert (msg[0][1].strip()
                          == (b'Well done, ${config.adminuser}!\r\n\r\n'
                              b'If you received this email, the email configuration '
                              b's=\r\neems to be correct.\r\n\r\n\r\n--=20\r\n'
                              b'Nextcloud - a safe home for all your data=\r\n\r\n'
                              b'This is an automatically sent email, please do not reply.'))
            '')
          ];
        };
    };

    test-helpers.init = ''
      stalwart.wait_for_unit("multi-user.target")
      stalwart.wait_until_succeeds("nc -vzw 2 localhost 587")

      nextcloud.succeed("nc -vzw 2 ${domain} 587")
      nextcloud.succeed("curl -sS --fail-with-body -u ${config.adminuser}:${config.adminpass} -H 'OCS-APIRequest: true' -X PUT http://nextcloud/ocs/v2.php/cloud/users/${config.adminuser} -H 'Content-Type: application/json' --data-raw '{\"key\":\"email\",\"value\":\"bob@${domain}\"}'")
      nextcloud.succeed("curl -sS --fail-with-body -u ${config.adminuser}:${config.adminpass} -H 'OCS-APIRequest: true' -X POST http://nextcloud/settings/admin/mailtest")

      stalwart.succeed("test-imap-read")
    '';
  }
)
