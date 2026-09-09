{
  lib,
  ...
}:
{
  name = "lemurs";
  meta = with lib.maintainers; {
    maintainers = [
      nullcube
      stunkymonkey
    ];
  };

  enableOCR = true;

  nodes.machine = _: {
    imports = [ ../common/user-account.nix ];
    services.displayManager.lemurs.enable = true;
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("multi-user.target")
    machine.wait_for_text("Login")
    machine.screenshot("postboot")

    with subtest("Log in as alice on a virtual console"):
      machine.send_chars("\n")
      machine.send_chars("alice\n")
      machine.sleep(1)
      machine.send_chars("foobar\n")
      machine.sleep(1)
      machine.wait_until_succeeds("pgrep -u alice bash")
      machine.screenshot("postlogin")
      machine.send_chars("touch done\n")
      machine.wait_for_file("/home/alice/done")
  '';
}
