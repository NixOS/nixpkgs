{
  lib,
  pkgs,
  latestKernel,
  ...
}:

{
  _module.args.latestKernel = lib.mkDefault false;
  name = "login";
  meta = {
    maintainers = [ ];
  };

  nodes.machine =
    { pkgs, lib, ... }:
    {
      boot.kernelPackages = lib.mkIf latestKernel pkgs.linuxPackages_latest;
    };

  testScript = ''
    machine.start(allow_reboot = True)

    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
    machine.screenshot("postboot")

    with subtest("create user"):
        machine.succeed("useradd -m alice")
        machine.succeed("(echo foobar; echo foobar) | passwd alice")

    with subtest("Check whether switching VTs works"):
        machine.fail("pgrep -f 'agetty.*tty2'")
        machine.send_key("alt-f2")
        machine.wait_until_succeeds("[ $(fgconsole) = 2 ]")
        machine.wait_for_unit("getty@tty2.service")
        machine.wait_until_succeeds("pgrep -f 'agetty.*tty2'")

    with subtest("Log in as alice on a virtual console"):
        machine.wait_until_tty_matches("2", "login: ")
        machine.send_chars("alice\n")
        machine.wait_until_tty_matches("2", "login: alice")
        machine.wait_until_succeeds("pgrep login")
        machine.wait_until_tty_matches("2", "Password: ")
        machine.send_chars("foobar\n")
        machine.wait_until_succeeds("pgrep -u alice bash")
        machine.send_chars("touch done\n")
        machine.wait_for_file("/home/alice/done")

    with subtest("Systemd gives and removes device ownership as needed"):
        machine.succeed("getfacl /dev/snd/timer | grep -q alice")
        machine.send_key("alt-f1")
        machine.wait_until_succeeds("[ $(fgconsole) = 1 ]")
        machine.fail("getfacl /dev/snd/timer | grep -q alice")
        machine.succeed("chvt 2")
        machine.wait_until_succeeds("getfacl /dev/snd/timer | grep -q alice")

    with subtest("Virtual console logout"):
        machine.send_chars("exit\n")
        machine.wait_until_fails("pgrep -u alice bash")
        machine.screenshot("getty")

    with subtest("Check whether ctrl-alt-delete works"):
        boot_id1 = machine.succeed("cat /proc/sys/kernel/random/boot_id").strip()
        assert boot_id1 != ""

        machine.reboot()

        boot_id2 = machine.succeed("cat /proc/sys/kernel/random/boot_id").strip()
        assert boot_id2 != ""

        assert boot_id1 != boot_id2
  '';
}
