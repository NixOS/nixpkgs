{ lib, pkgs, ... }:
let
  gpgKeyring = (
    pkgs.runCommand "gpg-keyring" { buildInputs = [ pkgs.gnupg ]; } ''
      mkdir -p $out
      export GNUPGHOME=$out
      cat > foo <<EOF
        %echo Generating a basic OpenPGP key
        %no-protection
        Key-Type: DSA
        Key-Length: 1024
        Subkey-Type: ELG-E
        Subkey-Length: 1024
        Name-Real: Foo Example
        Name-Email: foo@example.org
        Expire-Date: 0
        # Do a commit here, so that we can later print "done"
        %commit
        %echo done
      EOF
      gpg --batch --generate-key foo
      rm $out/S.gpg-agent $out/S.gpg-agent.*
    ''
  );
in
{
  name = "sks";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.gnupg ];

      services.sks.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("sks-db.service")
    machine.wait_for_open_port(11371)

    response = machine.succeed("curl -f -s http://127.0.0.1:11371/")
    assert "<title>SKS OpenPGP Public Key Server</title>" in response, "HTML title not found"

    # Copy the keyring
    machine.succeed("cp -R ${gpgKeyring} /tmp/GNUPGHOME")

    # Extract our GPG key id
    keyId = machine.succeed("GNUPGHOME=/tmp/GNUPGHOME gpg --list-keys | grep dsa1024 --after-context=1 | grep -v dsa1024").strip()

    # Send the key to our local keyserver
    machine.succeed("GNUPGHOME=/tmp/GNUPGHOME gpg --keyserver hkp://127.0.0.1:11371 --send-keys " + keyId)

    # Receive the key from our local keyserver to a separate directory
    machine.succeed("GNUPGHOME=$(mktemp -d) gpg --keyserver hkp://127.0.0.1:11371 --recv-keys " + keyId)
  '';
}
