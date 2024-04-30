{ config, lib, ... }:
{
  name = "swhkd";
  skipTypeCheck = true;
  skipLint = true;
  nodes.machine = { config, pkgs, ... }: {
    services.getty.autologinUser = "root";
    services.swhkd.enable = true;
    services.swhkd.swhkdrc = ''
escape
  touch /tmp/escape-pressed
'';
    programs.bash.loginShellInit = ''
echo login script run as $USER
swhks &
pkexec swhkd &
'';
  };

  testScript = ''
    import time
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep swhkd", timeout=12)
    time.sleep(4)
    machine.send_key("esc")
    machine.wait_for_file("/tmp/escape-pressed")
    machine.shutdown()
  '';
}
