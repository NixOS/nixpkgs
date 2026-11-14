{ lib, pkgs, ... }:

let
  gpg = lib.getExe' pkgs.gnupg "gpg";
  gpgconf = lib.getExe' pkgs.gnupg "gpgconf";

  # reads an armored secret key from stdin, mirrors adding it in the admin interface
  pgpImportKey = pkgs.writeText "pgp-import-key.rb" ''
    UserInfo.current_user_id = 1
    Setting.set('pgp_integration', true)
    raise 'PGP integration is not active' if !SecureMailing::PGP.active?

    PGPKey.create!(key: $stdin.read, passphrase: 'zammad')
  '';

  # sends a signed and encrypted mail to ourselves and processes it as an incoming mail
  pgpRoundtrip = pkgs.writeText "pgp-roundtrip.rb" ''
    raise 'PGP integration is not active' if !SecureMailing::PGP.active?

    body = 'This is a secret message.'
    mail = Channel::EmailBuild.build(
      from:         'zammad@example.com',
      to:           'zammad@example.com',
      body:         body,
      content_type: 'text/plain',
      security:     { type: 'PGP', sign: { success: true }, encryption: { success: true } }
    ).to_s
    raise 'outgoing mail is not encrypted' if mail.exclude?('-----BEGIN PGP MESSAGE-----')
    raise 'outgoing mail contains the plaintext' if mail.include?(body)

    parsed = Channel::EmailParser.new.parse(mail)
    SecureMailing.incoming(parsed)
    security = parsed['x-zammad-article-preferences'][:security]
    raise "decryption failed: #{security}" if !security[:encryption][:success]
    raise "signature verification failed: #{security}" if !security[:sign][:success]
    raise 'decrypted body does not match' if parsed[:body].exclude?(body)
  '';
in
{
  name = "zammad";

  meta.maintainers = with lib.maintainers; [
    taeer
    netali
  ];

  nodes.machine = {
    virtualisation = {
      memorySize = 2048;
    };

    services.zammad.enable = true;
    services.zammad.secretKeyBaseFile = pkgs.writeText "secret" ''
      52882ef142066e09ab99ce816ba72522e789505caba224a52d750ec7dc872c2c371b2fd19f16b25dfbdd435a4dd46cb3df9f82eb63fafad715056bdfe25740d6
    '';
  };

  testScript = ''
    def rails_runner(unit, script, stdin=""):
        """Run a rails runner script with the environment of the given zammad unit."""
        env = machine.succeed(f"systemctl show --property=Environment --value {unit}").split()
        workdir = machine.succeed(f"systemctl show --property=WorkingDirectory --value {unit}").strip()
        machine.succeed(
            f"{stdin} systemd-run --wait --pipe --collect"
            " --property=User=zammad --property=Group=zammad --property=PrivateTmp=yes"
            f" --property=WorkingDirectory={workdir}"
            + "".join(f" --setenv='{e}'" for e in env)
            + f" {workdir}/bin/rails runner {script}"
        )

    start_all()
    machine.wait_for_unit("postgresql.target")
    machine.wait_for_unit("redis-zammad.service")
    machine.wait_for_unit("zammad-web.service")
    machine.wait_for_unit("zammad-websocket.service")
    machine.wait_for_unit("zammad-worker.service")
    # wait for zammad to fully come up
    machine.sleep(120)

    # without the grep the command does not produce valid utf-8 for some reason
    with subtest("welcome screen loads"):
        machine.succeed(
            "curl -sSfL http://localhost:3000/ | grep '<title>Zammad Helpdesk</title>'"
        )

    with subtest("PGP key can be imported"):
        machine.succeed(
            "mkdir -m 700 /root/gnupg",
            "${gpg} --homedir /root/gnupg --batch --pinentry-mode loopback --passphrase zammad"
            " --quick-gen-key 'Zammad <zammad@example.com>' default default never",
        )
        rails_runner(
            "zammad-web",
            "${pgpImportKey}",
            stdin="${gpg} --homedir /root/gnupg --batch --pinentry-mode loopback --passphrase zammad"
            " --armor --export-secret-keys |",
        )
        machine.succeed("GNUPGHOME=/root/gnupg ${gpgconf} --kill gpg-agent")

    with subtest("worker can sign, encrypt, decrypt and verify PGP mails"):
        rails_runner("zammad-worker", "${pgpRoundtrip}")
        # temporary keyrings are cleaned up and no gpg-agent is left behind
        machine.fail("pgrep -u zammad gpg-agent")
        machine.fail("ls /var/lib/zammad/tmp | grep zammad-gnupg-keyring")
  '';
}
