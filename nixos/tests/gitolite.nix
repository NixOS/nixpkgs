{ pkgs, ... }:

let
  adminPrivateKey = pkgs.writeText "id_ed25519" ''
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACDu7qxYQAPdAU6RrhB3llk2N1v4PTwcVzcX1oX265uC3gAAAJBJiYxDSYmM
    QwAAAAtzc2gtZWQyNTUxOQAAACDu7qxYQAPdAU6RrhB3llk2N1v4PTwcVzcX1oX265uC3g
    AAAEDE1W6vMwSEUcF1r7Hyypm/+sCOoDmKZgPxi3WOa1mD2u7urFhAA90BTpGuEHeWWTY3
    W/g9PBxXNxfWhfbrm4LeAAAACGJmb0BtaW5pAQIDBAU=
    -----END OPENSSH PRIVATE KEY-----
  '';

  adminPublicKey = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7urFhAA90BTpGuEHeWWTY3W/g9PBxXNxfWhfbrm4Le root@client
  '';

  alicePrivateKey = pkgs.writeText "id_ed25519" ''
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACBbeWvHh/AWGWI6EIc1xlSihyXtacNQ9KeztlW/VUy8wQAAAJAwVQ5VMFUO
    VQAAAAtzc2gtZWQyNTUxOQAAACBbeWvHh/AWGWI6EIc1xlSihyXtacNQ9KeztlW/VUy8wQ
    AAAEB7lbfkkdkJoE+4TKHPdPQWBKLSx+J54Eg8DaTr+3KoSlt5a8eH8BYZYjoQhzXGVKKH
    Je1pw1D0p7O2Vb9VTLzBAAAACGJmb0BtaW5pAQIDBAU=
    -----END OPENSSH PRIVATE KEY-----
  '';

  alicePublicKey = pkgs.writeText "id_ed25519.pub" ''
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

  bobPublicKey = pkgs.writeText "id_ed25519.pub" ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZNonUP1ePHLrvn0W9D2hdN6zWWZYFyJc+QR6pOKQEw bob@client
  '';

  gitoliteAdminConfSnippet = pkgs.writeText "gitolite-admin-conf-snippet" ''
    repo alice-project
        RW+     =   alice
  '';
in
{
  name = "gitolite";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ bjornfor ];
  };

  nodes = {

    server =
      { ... }:
      {
        services.gitolite = {
          enable = true;
          adminPubkey = adminPublicKey;
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

    with subtest("can setup ssh keys on system"):
        client.succeed(
            "mkdir -p ~root/.ssh",
            "cp ${adminPrivateKey} ~root/.ssh/id_ed25519",
            "chmod 600 ~root/.ssh/id_ed25519",
        )
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

    with subtest("gitolite server starts"):
        server.wait_for_unit("gitolite-init.service")
        server.wait_for_unit("sshd.service")
        client.succeed("ssh -n gitolite@server info")

    with subtest("admin can clone and configure gitolite-admin.git"):
        client.succeed(
            "git clone gitolite@server:gitolite-admin.git",
            "git config --global user.name 'System Administrator'",
            "git config --global user.email root\@domain.example",
            "cp ${alicePublicKey} gitolite-admin/keydir/alice.pub",
            "cp ${bobPublicKey} gitolite-admin/keydir/bob.pub",
            "(cd gitolite-admin && git add . && git commit -m 'Add keys for alice, bob' && git push)",
            "cat ${gitoliteAdminConfSnippet} >> gitolite-admin/conf/gitolite.conf",
            "(cd gitolite-admin && git add . && git commit -m 'Add repo for alice' && git push)",
        )

    with subtest("non-admins cannot clone gitolite-admin.git"):
        client.fail("sudo -i -u alice git clone gitolite@server:gitolite-admin.git")
        client.fail("sudo -i -u bob git clone gitolite@server:gitolite-admin.git")

    with subtest("non-admins can clone testing.git"):
        client.succeed("sudo -i -u alice git clone gitolite@server:testing.git")
        client.succeed("sudo -i -u bob git clone gitolite@server:testing.git")

    with subtest("alice can clone alice-project.git"):
        client.succeed("sudo -i -u alice git clone gitolite@server:alice-project.git")

    with subtest("bob cannot clone alice-project.git"):
        client.fail("sudo -i -u bob git clone gitolite@server:alice-project.git")
  '';
}
