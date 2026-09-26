{ pkgs, lib, ... }:

let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilPrivateKey
    snakeOilPublicKey
    snakeOilEd25519PrivateKey
    snakeOilEd25519PublicKey
    ;

  keepFile = "keep.txt";
  keepFileData = "This file should be backed up.";
  excludedFile = "secret.txt";
  excludedFileData = "Should not be backed up!";
in
{
  name = "duplicity";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  containers.client =
    let
      dataDir = "/data";
    in
    {
      systemd.tmpfiles.settings."10-duplicity-test" = {
        ${dataDir}.d.mode = "0600";
        "${dataDir}/${keepFile}".f = {
          mode = "0644";
          argument = keepFileData;
        };
        "${dataDir}/${excludedFile}".f = {
          mode = "0644";
          argument = excludedFileData;
        };
      };

      programs.ssh = {
        systemd-ssh-proxy.enable = false;
        knownHosts.server = {
          hostNames = [ "server" ];
          publicKey = snakeOilPublicKey;
        };
        extraConfig = ''
          Host server
            IdentityFile ${snakeOilEd25519PrivateKey}
        '';
      };

      services.duplicity = {
        enable = true;
        root = dataDir;
        exclude = [ "${dataDir}/${excludedFile}" ];
        targetUrl = "scp://root@server//root/backup";
        frequency = null; # triggered manually in the test script
        fullIfOlderThan = "always";
        extraFlags = [
          "--no-encryption"
          "--volsize"
          "1"
        ];
      };
    };

  containers.server =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.duplicity ];

      systemd.tmpfiles.settings."10-duplicity-test" = {
        "/root/backup".d.mode = "0700";
        "/root/restore".d.mode = "0700";
      };

      services.openssh = {
        enable = true;
        hostKeys = [
          {
            type = "ecdsa";
            path = "${snakeOilPrivateKey}";
          }
        ];
      };

      users.users.root.openssh.authorizedKeys.keys = [ snakeOilEd25519PublicKey ];
    };

  testScript = ''
    start_all()

    client.wait_for_unit("multi-user.target")
    server.wait_for_unit("multi-user.target")
    server.wait_for_open_port(22)

    client.systemctl("start --wait duplicity.service")
    client.fail("systemctl is-failed duplicity.service")

    server.succeed(
        "duplicity --no-encryption --volsize 1 restore file:///root/backup /root/restore"
    )

    server.succeed("test -f /root/restore/${keepFile}")
    assert "${keepFileData}" in server.succeed("cat /root/restore/${keepFile}")

    server.fail("test -e /root/restore/${excludedFile}")
  '';
}
