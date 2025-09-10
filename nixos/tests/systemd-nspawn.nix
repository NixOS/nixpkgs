{ pkgs, lib, ... }:
let
  gpgKeyring = import ./common/gpg-keyring.nix { inherit pkgs; };

  nspawnImages = (
    pkgs.runCommand "localhost"
      {
        buildInputs = [
          pkgs.coreutils
          pkgs.gnupg
        ];
      }
      ''
        mkdir -p $out
        cd $out

        # produce a testimage.raw
        dd if=/dev/urandom of=$out/testimage.raw bs=$((1024*1024+7)) count=5

        # produce a testimage2.tar.xz, containing the hello store path
        tar cvJpf testimage2.tar.xz ${pkgs.hello}

        # produce signature(s)
        sha256sum testimage* > SHA256SUMS
        export GNUPGHOME="$(mktemp -d)"
        cp -R ${gpgKeyring}/* $GNUPGHOME
        gpg --batch --sign --detach-sign --output SHA256SUMS.gpg SHA256SUMS
      ''
  );
in
{
  name = "systemd-nspawn";

  nodes = {
    server =
      { pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 80 ];
        services.nginx = {
          enable = true;
          virtualHosts."server".root = nspawnImages;
        };
      };
    client =
      { pkgs, ... }:
      {
        environment.etc."systemd/import-pubring.gpg".source = "${gpgKeyring}/pubkey.gpg";
      };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("nginx.service")
    client.systemctl("start network-online.target")
    client.wait_for_unit("network-online.target")
    client.succeed("machinectl pull-raw --verify=signature http://server/testimage.raw")
    client.succeed(
        "cmp /var/lib/machines/testimage.raw ${nspawnImages}/testimage.raw"
    )
    client.succeed("machinectl pull-tar --verify=signature http://server/testimage2.tar.xz")
    client.succeed(
        "cmp /var/lib/machines/testimage2/${pkgs.hello}/bin/hello ${pkgs.hello}/bin/hello"
    )
  '';
}
