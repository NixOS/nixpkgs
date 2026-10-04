# Tests downloading a signed update artifact from a server to a target machine.
# This test does not rely on the `systemd.timer` units provided by the
# `systemd-sysupdate` module but triggers the `updatectl` tool directly to
# demonstrate how to initiate updates manually.

{ lib, pkgs, ... }:

let
  gpgKeyring = import ./common/gpg-keyring.nix { inherit pkgs; };
in
{
  name = "systemd-sysupdate";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes = {
    server =
      { pkgs, ... }:
      {
        networking.firewall.enable = false;
        services.nginx = {
          enable = true;
          virtualHosts."server" = {
            root = pkgs.runCommand "sysupdate-artifacts" { buildInputs = [ pkgs.gnupg ]; } ''
              mkdir -p $out
              cd $out

              echo "nixos" > nixos_1.txt
              sha256sum nixos_1.txt > SHA256SUMS

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
        timerConfig = {
          OnActiveSec = 0;
          RandomizedDelaySec = 0;
        };
        transfers = {
          "text-file" = {
            Source = {
              Type = "url-file";
              Path = "http://server/";
              MatchPattern = "nixos_@v.txt";
            };
            Target = {
              Path = "/";
              MatchPattern = [ "nixos_@v.txt" ];
            };
          };
        };
      };

      environment.etc."systemd/import-pubring.gpg".source = "${gpgKeyring}/pubkey.gpg";
    };
  };

  testScript = ''
    import datetime as dt

    server.wait_for_unit("nginx.service")

    def update_done(_last_try: bool) -> bool:
        info = target.get_unit_info("systemd-sysupdate-update.service")
        return info["InactiveEnterTimestampMonotonic"] != "0"
    retry(update_done, timeout=dt.timedelta(seconds=60))
    assert "nixos" in target.wait_until_succeeds("cat /nixos_1.txt", timeout=dt.timedelta(seconds=5))
    target.succeed("rm /nixos_1.txt");

    print(target.succeed("updatectl list"))
    target.succeed("updatectl update")
    assert "nixos" in target.wait_until_succeeds("cat /nixos_1.txt", timeout=dt.timedelta(seconds=5))
  '';
}
