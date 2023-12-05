# Tests downloading a signed update aritfact from a server to a target machine.
# This test does not rely on the `systemd.timer` units provided by the
# `systemd-sysupdate` module but triggers the `systemd-sysupdate` service
# manually to make the test more robust.

{ lib, pkgs, ... }:

let
  gpgKeyring = import ./common/gpg-keyring.nix { inherit pkgs; };
in
{
  name = "systemd-sysupdate";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes = {
    server = { pkgs, ... }: {
      networking.firewall.enable = false;
      services.nginx = {
        enable = true;
        virtualHosts."server" = {
          root = pkgs.runCommand "sysupdate-artifacts" { buildInputs = [ pkgs.gnupg ]; } ''
            mkdir -p $out
            cd $out

            echo "nixos" > nixos_1.efi
            sha256sum nixos_1.efi > SHA256SUMS

            export GNUPGHOME="$(mktemp -d)"
            cp -R ${gpgKeyring}/* $GNUPGHOME

            gpg --batch --sign --detach-sign --output SHA256SUMS.gpg SHA256SUMS
          '';
        };
      };
    };

    target = {
      systemd.sysupdate = {
        enable = true;
        transfers = {
          "uki" = {
            Source = {
              Type = "url-file";
              Path = "http://server/";
              MatchPattern = "nixos_@v.efi";
            };
            Target = {
              Path = "/boot/EFI/Linux";
              MatchPattern = "nixos_@v.efi";
            };
          };
        };
      };

      environment.etc."systemd/import-pubring.gpg".source = "${gpgKeyring}/pubkey.gpg";
    };
  };

  testScript = ''
    server.wait_for_unit("nginx.service")

    target.succeed("systemctl start systemd-sysupdate")
    assert "nixos" in target.wait_until_succeeds("cat /boot/EFI/Linux/nixos_1.efi", timeout=5)
  '';
}
