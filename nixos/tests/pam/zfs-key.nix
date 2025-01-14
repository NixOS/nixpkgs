import ../make-test-python.nix (
  { ... }:

  let
    userPassword = "password";
    mismatchPass = "mismatch";
  in
  {
    name = "pam-zfs-key";

    nodes.machine =
      { ... }:
      {
        boot.supportedFilesystems = [ "zfs" ];

        networking.hostId = "12345678";

        security.pam.zfs.enable = true;

        users.users = {
          alice = {
            isNormalUser = true;
            password = userPassword;
          };
          bob = {
            isNormalUser = true;
            password = userPassword;
          };
        };
      };

    testScript =
      { nodes, ... }:
      let
        homes = nodes.machine.security.pam.zfs.homes;
        pool = builtins.head (builtins.split "/" homes);
      in
      ''
        machine.wait_for_unit("multi-user.target")
        machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

        with subtest("Create encrypted ZFS datasets"):
          machine.succeed("truncate -s 64M /testpool.img")
          machine.succeed("zpool create -O canmount=off '${pool}' /testpool.img")
          machine.succeed("zfs create -o canmount=off -p '${homes}'")
          machine.succeed("echo ${userPassword} | zfs create -o canmount=noauto -o encryption=on -o keyformat=passphrase '${homes}/alice'")
          machine.succeed("zfs unload-key '${homes}/alice'")
          machine.succeed("echo ${mismatchPass} | zfs create -o canmount=noauto -o encryption=on -o keyformat=passphrase '${homes}/bob'")
          machine.succeed("zfs unload-key '${homes}/bob'")

        with subtest("Switch to tty2"):
          machine.fail("pgrep -f 'agetty.*tty2'")
          machine.send_key("alt-f2")
          machine.wait_until_succeeds("[ $(fgconsole) = 2 ]")
          machine.wait_for_unit("getty@tty2.service")
          machine.wait_until_succeeds("pgrep -f 'agetty.*tty2'")

        with subtest("Log in as user with home locked by login password"):
          machine.wait_until_tty_matches("2", "login: ")
          machine.send_chars("alice\n")
          machine.wait_until_tty_matches("2", "login: alice")
          machine.wait_until_succeeds("pgrep login")
          machine.wait_until_tty_matches("2", "Password: ")
          machine.send_chars("${userPassword}\n")
          machine.wait_until_succeeds("pgrep -u alice bash")
          machine.succeed("mount | grep ${homes}/alice")

        with subtest("Switch to tty3"):
          machine.fail("pgrep -f 'agetty.*tty3'")
          machine.send_key("alt-f3")
          machine.wait_until_succeeds("[ $(fgconsole) = 3 ]")
          machine.wait_for_unit("getty@tty3.service")
          machine.wait_until_succeeds("pgrep -f 'agetty.*tty3'")

        with subtest("Log in as user with home locked by password different from login"):
          machine.wait_until_tty_matches("3", "login: ")
          machine.send_chars("bob\n")
          machine.wait_until_tty_matches("3", "login: bob")
          machine.wait_until_succeeds("pgrep login")
          machine.wait_until_tty_matches("3", "Password: ")
          machine.send_chars("${userPassword}\n")
          machine.wait_until_succeeds("pgrep -u bob bash")
          machine.fail("mount | grep ${homes}/bob")
      '';
  }
)
