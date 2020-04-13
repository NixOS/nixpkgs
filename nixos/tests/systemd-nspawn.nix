import ./make-test-python.nix ({pkgs, lib, ...}:
let
  gpgKeyring = (pkgs.runCommand "gpg-keyring" { buildInputs = [ pkgs.gnupg ]; } ''
    mkdir -p $out
    export GNUPGHOME=$out
    cat > foo <<EOF
      %echo Generating a basic OpenPGP key
      %no-protection
      Key-Type: DSA
      Key-Length: 1024
      Subkey-Type: ELG-E
      Subkey-Length: 1024
      Name-Real: Joe Tester
      Name-Email: joe@foo.bar
      Expire-Date: 0
      # Do a commit here, so that we can later print "done"
      %commit
      %echo done
    EOF
    gpg --batch --generate-key foo
    rm $out/S.gpg-agent $out/S.gpg-agent.*
    gpg --export joe@foo.bar -a > $out/pubkey.gpg
  '');

  nspawnImages = (pkgs.runCommand "localhost" { buildInputs = [ pkgs.coreutils pkgs.gnupg ]; } ''
    mkdir -p $out
    cd $out
    dd if=/dev/urandom of=$out/testimage.raw bs=$((1024*1024+7)) count=5
    sha256sum testimage.raw > SHA256SUMS
    export GNUPGHOME="$(mktemp -d)"
    cp -R ${gpgKeyring}/* $GNUPGHOME
    gpg --batch --sign --detach-sign --output SHA256SUMS.gpg SHA256SUMS
  '');
in {
  name = "systemd-nspawn";

  nodes = {
    server = { pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 80 ];
      services.nginx = {
        enable = true;
        virtualHosts."server".root = nspawnImages;
      };
    };
    client = { pkgs, ... }: {
      environment.etc."systemd/import-pubring.gpg".source = "${gpgKeyring}/pubkey.gpg";
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("nginx.service")
    client.wait_for_unit("network-online.target")
    client.succeed("machinectl pull-raw --verify=signature http://server/testimage.raw")
    client.succeed(
        "cmp /var/lib/machines/testimage.raw ${nspawnImages}/testimage.raw"
    )
  '';
})
