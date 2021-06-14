import ./make-test-python.nix ({ pkgs, ...} : {
  name = "nano";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { lib, ... }: {
    environment.systemPackages = [ pkgs.nano ];
  };

  testScript = { ... }: ''
    start_all()

    with subtest("Create user and log in"):
        machine.wait_for_unit("multi-user.target")
        machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
        machine.succeed("useradd -m alice")
        machine.succeed("(echo foobar; echo foobar) | passwd alice")
        machine.wait_until_tty_matches(1, "login: ")
        machine.send_chars("alice\n")
        machine.wait_until_tty_matches(1, "login: alice")
        machine.wait_until_succeeds("pgrep login")
        machine.wait_until_tty_matches(1, "Password: ")
        machine.send_chars("foobar\n")
        machine.wait_until_succeeds("pgrep -u alice bash")
        machine.screenshot("prompt")

    with subtest("Use nano"):
        machine.send_chars("nano /tmp/foo")
        machine.send_key("ret")
        machine.sleep(2)
        machine.send_chars("42")
        machine.sleep(1)
        machine.send_key("ctrl-x")
        machine.sleep(1)
        machine.send_key("y")
        machine.sleep(1)
        machine.screenshot("nano")
        machine.sleep(1)
        machine.send_key("ret")
        machine.wait_for_file("/tmp/foo")
        assert "42" in machine.succeed("cat /tmp/foo")
  '';
})
