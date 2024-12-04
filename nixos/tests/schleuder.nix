let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
import ./make-test-python.nix {
  name = "schleuder";
  nodes.machine = { pkgs, ... }: {
    imports = [ ./common/user-account.nix ];
    services.postfix = {
      enable = true;
      enableSubmission = true;
      tlsTrustedAuthorities = "${certs.ca.cert}";
      sslCert = "${certs.${domain}.cert}";
      sslKey = "${certs.${domain}.key}";
      inherit domain;
      destination = [ domain ];
      localRecipients = [ "root" "alice" "bob" ];
    };
    services.schleuder = {
      enable = true;
      # Don't do it like this in production! The point of this setting
      # is to allow loading secrets from _outside_ the world-readable
      # Nix store.
      extraSettingsFile = pkgs.writeText "schleuder-api-keys.yml" ''
        api:
          valid_api_keys:
            - fnord
      '';
      lists = [ "security@${domain}" ];
      settings.api = {
        tls_cert_file = "${certs.${domain}.cert}";
        tls_key_file = "${certs.${domain}.key}";
      };
    };

    environment.systemPackages = [
      pkgs.gnupg
      pkgs.msmtp
      (pkgs.writeScriptBin "do-test" ''
        #!${pkgs.runtimeShell}
        set -exuo pipefail

        # Generate a GPG key with no passphrase and export it
        sudo -u alice gpg --passphrase-fd 0 --batch --yes --quick-generate-key 'alice@${domain}' rsa4096 sign,encr < <(echo)
        sudo -u alice gpg --armor --export alice@${domain} > alice.asc
        # Create a new mailing list with alice as the owner, and alice's key
        schleuder-cli list new security@${domain} alice@${domain} alice.asc

        # Send an email from a non-member of the list. Use --auto-from so we don't have to specify who it's from twice.
        msmtp --auto-from security@${domain} --host=${domain} --port=25 --tls --tls-starttls <<EOF
          Subject: really big security issue!!
          From: root@${domain}

          I found a big security problem!
        EOF

        # Wait for delivery
        (set +o pipefail; journalctl -f -n 1000 -u postfix | grep -m 1 'delivered to maildir')

        # There should be exactly one email
        mail=(/var/spool/mail/alice/new/*)
        [[ "''${#mail[@]}" = 1 ]]

        # Find the fingerprint of the mailing list key
        read list_key_fp address < <(schleuder-cli keys list security@${domain} | grep security@)
        schleuder-cli keys export security@${domain} $list_key_fp > list.asc

        # Import the key into alice's keyring, so we can verify it as well as decrypting
        sudo -u alice gpg --import <list.asc
        # And perform the decryption.
        sudo -u alice gpg -d $mail >decrypted
        # And check that the text matches.
        grep "big security problem" decrypted
      '')

      # For debugging:
      # pkgs.vim pkgs.openssl pkgs.sqliteinteractive
    ];

    security.pki.certificateFiles = [ certs.ca.cert ];

    # Since we don't have internet here, use dnsmasq to provide MX records from /etc/hosts
    services.dnsmasq = {
      enable = true;
      settings.selfmx = true;
    };

    networking.extraHosts = ''
      127.0.0.1 ${domain}
    '';

    # schleuder-cli's config is not quite optimal in several ways:
    # - A fingerprint _must_ be pinned, it doesn't even have an option
    #   to trust the PKI
    # - It compares certificate fingerprints rather than key
    #   fingerprints, so renewals break the pin (though that's not
    #   relevant for this test)
    # - It compares them as strings, which means we need to match the
    #   expected format exactly. This means removing the :s and
    #   lowercasing it.
    # Refs:
    # https://0xacab.org/schleuder/schleuder-cli/-/issues/16
    # https://0xacab.org/schleuder/schleuder-cli/-/blob/f8895b9f47083d8c7b99a2797c93f170f3c6a3c0/lib/schleuder-cli/helper.rb#L230-238
    systemd.tmpfiles.rules = let cliconfig = pkgs.runCommand "schleuder-cli.yml"
      {
        nativeBuildInputs = [ pkgs.jq pkgs.openssl ];
      } ''
      fp=$(openssl x509 -in ${certs.${domain}.cert} -noout -fingerprint -sha256 | cut -d = -f 2 | tr -d : | tr 'A-Z' 'a-z')
      cat > $out <<EOF
      host: localhost
      port: 4443
      tls_fingerprint: "$fp"
      api_key: fnord
      EOF
    ''; in
      [
        "L+ /root/.schleuder-cli/schleuder-cli.yml - - - - ${cliconfig}"
      ];
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("nc -z localhost 4443")
    machine.succeed("do-test")
  '';
}
