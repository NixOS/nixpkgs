# Rudimentary test checking that the Stalwart email server can:
# - receive some message through SMTP submission, then
# - serve this message through IMAP.
{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },

  lib ? pkgs.lib,
}:
let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
  makeTest = import ./make-test-python.nix;
  mkTestName = pkg: "${pkg.pname}_${pkg.version}";
  stalwartPackages = {
    inherit (pkgs) stalwart-mail_0_6 stalwart-mail;
  };
  stalwartAtLeast = lib.versionAtLeast;
  makeStalwartTest =
    {
      package,
      name ? mkTestName package,
    }:
    makeTest {
      inherit name;
      meta.maintainers = with lib.maintainers; [
        happysalada
        pacien
        onny
      ];

      nodes.machine =
        { lib, ... }:
        {

          security.pki.certificateFiles = [ certs.ca.cert ];

          services.stalwart-mail = {
            enable = true;
            inherit package;
            settings = {
              server.hostname = domain;

              # TODO: Remove backwards compatibility as soon as we drop legacy version 0.6.0
              certificate."snakeoil" =
                let
                  certPath =
                    if stalwartAtLeast package.version "0.7.0" then
                      "%{file://${certs.${domain}.cert}}%"
                    else
                      "file://${certs.${domain}.cert}";
                  keyPath =
                    if stalwartAtLeast package.version "0.7.0" then
                      "%{file:${certs.${domain}.key}}%"
                    else
                      "file://${certs.${domain}.key}";
                in
                {
                  cert = certPath;
                  private-key = keyPath;
                };

              server.tls = {
                certificate = "snakeoil";
                enable = true;
                implicit = false;
              };

              server.listener = {
                "smtp-submission" = {
                  bind = [ "[::]:587" ];
                  protocol = "smtp";
                };

                "imap" = {
                  bind = [ "[::]:143" ];
                  protocol = "imap";
                };
              };

              session.auth.mechanisms = "[plain]";
              session.auth.directory = "'in-memory'";
              storage.directory = "in-memory";

              session.rcpt.directory = "'in-memory'";
              queue.outbound.next-hop = "'local'";

              directory."in-memory" = {
                type = "memory";
                # TODO: Remove backwards compatibility as soon as we drop legacy version 0.6.0
                principals =
                  let
                    condition = if stalwartAtLeast package.version "0.7.0" then "class" else "type";
                  in
                  builtins.map (p: p // { ${condition} = "individual"; }) [
                    {
                      name = "alice";
                      secret = "foobar";
                      email = [ "alice@${domain}" ];
                    }
                    {
                      name = "bob";
                      secret = "foobar";
                      email = [ "bob@${domain}" ];
                    }
                  ];
              };
            };
          };

          environment.systemPackages = [
            (pkgs.writers.writePython3Bin "test-smtp-submission" { } ''
              from smtplib import SMTP

              with SMTP('localhost', 587) as smtp:
                  smtp.starttls()
                  smtp.login('alice', 'foobar')
                  smtp.sendmail(
                      'alice@${domain}',
                      'bob@${domain}',
                      """
                          From: alice@${domain}
                          To: bob@${domain}
                          Subject: Some test message

                          This is a test message.
                      """.strip()
                  )
            '')

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
                  assert msg[0][1].strip() == b'This is a test message.'
            '')
          ];

        };

      testScript = ''
        start_all()
        machine.wait_for_unit("stalwart-mail.service")
        machine.wait_for_open_port(587)
        machine.wait_for_open_port(143)

        machine.succeed("test-smtp-submission")
        machine.succeed("test-imap-read")
      '';
    };
in
lib.mapAttrs (_: package: makeStalwartTest { inherit package; }) stalwartPackages
