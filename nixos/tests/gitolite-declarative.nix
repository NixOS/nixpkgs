{ pkgs, ... }:

let
  alicePrivateKey = pkgs.writeText "id_ed25519" ''
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACBbeWvHh/AWGWI6EIc1xlSihyXtacNQ9KeztlW/VUy8wQAAAJAwVQ5VMFUO
    VQAAAAtzc2gtZWQyNTUxOQAAACBbeWvHh/AWGWI6EIc1xlSihyXtacNQ9KeztlW/VUy8wQ
    AAAEB7lbfkkdkJoE+4TKHPdPQWBKLSx+J54Eg8DaTr+3KoSlt5a8eH8BYZYjoQhzXGVKKH
    Je1pw1D0p7O2Vb9VTLzBAAAACGJmb0BtaW5pAQIDBAU=
    -----END OPENSSH PRIVATE KEY-----
  '';

  alicePublicKey = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFt5a8eH8BYZYjoQhzXGVKKHJe1pw1D0p7O2Vb9VTLzB alice@client
  '';

  bobPrivateKey = pkgs.writeText "id_ed25519" ''
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACCWTaJ1D9Xjxy6759FvQ9oXTes1lmWBciXPkEeqTikBMAAAAJDQBmNV0AZj
    VQAAAAtzc2gtZWQyNTUxOQAAACCWTaJ1D9Xjxy6759FvQ9oXTes1lmWBciXPkEeqTikBMA
    AAAEDM1IYYFUwk/IVxauha9kuR6bbRtT3gZ6ZA0GLb9txb/pZNonUP1ePHLrvn0W9D2hdN
    6zWWZYFyJc+QR6pOKQEwAAAACGJmb0BtaW5pAQIDBAU=
    -----END OPENSSH PRIVATE KEY-----
  '';

  bobPublicKey = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZNonUP1ePHLrvn0W9D2hdN6zWWZYFyJc+QR6pOKQEw bob@client
  '';
in
{
  name = "gitolite-declarative";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ berber ];
  };

  nodes = {

    server =
      { ... }:
      {
        services.gitolite = {
          enable = true;
          repos = {
            "alice-project" = {
              access = [
                {
                  perm = "RW+";
                  users = [ "alice" ];
                }
              ];
            };
            "shared" = {
              access = [
                {
                  perm = "RW+";
                  users = [
                    "alice"
                    "bob"
                  ];
                }
              ];
            };
          };
          keys = {
            alice = [ alicePublicKey ];
            bob = [ bobPublicKey ];
          };
        };
        services.openssh.enable = true;
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.git ];
        programs.ssh.extraConfig = ''
          Host *
            UserKnownHostsFile /dev/null
            StrictHostKeyChecking no
            # there's nobody around that can input password
            PreferredAuthentications publickey
        '';
        users.users.alice = {
          isNormalUser = true;
        };
        users.users.bob = {
          isNormalUser = true;
        };
      };

  };

  testScript = ''
    start_all()

    with subtest("gitolite server starts"):
        server.wait_for_unit("gitolite-init.service")
        server.wait_for_unit("sshd.service")

    with subtest("gitolite.conf is a symlink into the nix store"):
        server.succeed("test -L /var/lib/gitolite/.gitolite/conf/gitolite.conf")

    with subtest("gitolite.conf contains declared repos"):
        server.succeed("grep -q 'repo alice-project' /var/lib/gitolite/.gitolite/conf/gitolite.conf")
        server.succeed("grep -q 'repo shared' /var/lib/gitolite/.gitolite/conf/gitolite.conf")

    with subtest("keydir contains exactly the declared keys"):
        server.succeed("test -f /var/lib/gitolite/.gitolite/keydir/alice.pub")
        server.succeed("test -f /var/lib/gitolite/.gitolite/keydir/bob.pub")
        server.succeed("test $(ls /var/lib/gitolite/.gitolite/keydir/*.pub | wc -l) -eq 2")

    with subtest("gitolite-admin.git does not exist"):
        server.fail("test -d /var/lib/gitolite/repositories/gitolite-admin.git")

    with subtest("setup ssh keys on client"):
        client.succeed(
            "sudo -u alice mkdir -p ~alice/.ssh",
            "sudo -u alice cp ${alicePrivateKey} ~alice/.ssh/id_ed25519",
            "sudo -u alice chmod 600 ~alice/.ssh/id_ed25519",
        )
        client.succeed(
            "sudo -u bob mkdir -p ~bob/.ssh",
            "sudo -u bob cp ${bobPrivateKey} ~bob/.ssh/id_ed25519",
            "sudo -u bob chmod 600 ~bob/.ssh/id_ed25519",
        )

    with subtest("alice can clone alice-project"):
        client.succeed("sudo -i -u alice git clone gitolite@server:alice-project.git")

    with subtest("bob cannot clone alice-project"):
        client.fail("sudo -i -u bob git clone gitolite@server:alice-project.git")

    with subtest("alice and bob can clone shared"):
        client.succeed("sudo -i -u alice git clone gitolite@server:shared.git")
        client.succeed("sudo -i -u bob git clone gitolite@server:shared.git")
  '';
}
