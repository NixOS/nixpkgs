{ pkgs, ... }:

pkgs.runCommand "gpg-keyring" { nativeBuildInputs = [ pkgs.gnupg ]; } ''
  mkdir -p $out
  export GNUPGHOME=$out
  cat > foo <<EOF
    %echo Generating a basic OpenPGP key
    %no-protection
    Key-Type: EdDSA
    Key-Curve: ed25519
    Name-Real: Bob Foobar
    Name-Email: bob@foo.bar
    Expire-Date: 0
    # Do a commit here, so that we can later print "done"
    %commit
    %echo done
  EOF
  gpg --batch --generate-key foo
  rm $out/S.gpg-agent $out/S.gpg-agent.*
  gpg --export bob@foo.bar -a > $out/pubkey.gpg
''
