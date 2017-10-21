import ./make-test.nix ({ pkgs, ...}:

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

  gitoliteAdminConfSnippet = ''
    repo alice-project
        RW+     =   alice
  '';
in
{
  name = "gitolite";

  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bjornfor ];
  };

  nodes = {

    server =
      { config, pkgs, lib, ... }:
      {
        services.gitolite = {
          enable = true;
          adminPubkey = adminPublicKey;
        };
        services.openssh.enable = true;
      };

    client =
      { config, pkgs, lib, ... }:
      {
        environment.systemPackages = [ pkgs.git ];
        programs.ssh.extraConfig = ''
          Host *
            UserKnownHostsFile /dev/null
            StrictHostKeyChecking no
            # there's nobody around that can input password
            PreferredAuthentications publickey
        '';
        users.extraUsers.alice = { isNormalUser = true; };
        users.extraUsers.bob = { isNormalUser = true; };
      };

  };

  testScript = ''
    startAll;

    subtest "can setup ssh keys on system", sub {
      $client->mustSucceed("mkdir -p ~root/.ssh");
      $client->mustSucceed("cp ${adminPrivateKey} ~root/.ssh/id_ed25519");
      $client->mustSucceed("chmod 600 ~root/.ssh/id_ed25519");

      $client->mustSucceed("sudo -u alice mkdir -p ~alice/.ssh");
      $client->mustSucceed("sudo -u alice cp ${alicePrivateKey} ~alice/.ssh/id_ed25519");
      $client->mustSucceed("sudo -u alice chmod 600 ~alice/.ssh/id_ed25519");

      $client->mustSucceed("sudo -u bob mkdir -p ~bob/.ssh");
      $client->mustSucceed("sudo -u bob cp ${bobPrivateKey} ~bob/.ssh/id_ed25519");
      $client->mustSucceed("sudo -u bob chmod 600 ~bob/.ssh/id_ed25519");
    };

    subtest "gitolite server starts", sub {
      $server->waitForUnit("gitolite-init.service");
      $server->waitForUnit("sshd.service");
      $client->mustSucceed('ssh gitolite@server info');
    };

    subtest "admin can clone and configure gitolite-admin.git", sub {
      $client->mustSucceed('git clone gitolite@server:gitolite-admin.git');
      $client->mustSucceed("git config --global user.name 'System Administrator'");
      $client->mustSucceed("git config --global user.email root\@domain.example");
      $client->mustSucceed("cp ${alicePublicKey} gitolite-admin/keydir/alice.pub");
      $client->mustSucceed("cp ${bobPublicKey} gitolite-admin/keydir/bob.pub");
      $client->mustSucceed('(cd gitolite-admin && git add . && git commit -m "Add keys for alice, bob" && git push)');
      $client->mustSucceed("printf '${gitoliteAdminConfSnippet}' >> gitolite-admin/conf/gitolite.conf");
      $client->mustSucceed('(cd gitolite-admin && git add . && git commit -m "Add repo for alice" && git push)');
    };

    subtest "non-admins cannot clone gitolite-admin.git", sub {
      $client->mustFail('sudo -i -u alice git clone gitolite@server:gitolite-admin.git');
      $client->mustFail('sudo -i -u bob git clone gitolite@server:gitolite-admin.git');
    };

    subtest "non-admins can clone testing.git", sub {
      $client->mustSucceed('sudo -i -u alice git clone gitolite@server:testing.git');
      $client->mustSucceed('sudo -i -u bob git clone gitolite@server:testing.git');
    };

    subtest "alice can clone alice-project.git", sub {
      $client->mustSucceed('sudo -i -u alice git clone gitolite@server:alice-project.git');
    };

    subtest "bob cannot clone alice-project.git", sub {
      $client->mustFail('sudo -i -u bob git clone gitolite@server:alice-project.git');
    };
  '';
})
