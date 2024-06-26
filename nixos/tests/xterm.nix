import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "xterm";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ nequissimus ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        imports = [ ./common/x11.nix ];
        services.xserver.desktopManager.xterm.enable = false;
      };

    testScript = ''
      machine.wait_for_x()
      machine.succeed("DISPLAY=:0 xterm -title testterm -class testterm -fullscreen >&2 &")
      machine.sleep(2)
      machine.send_chars("echo $XTERM_VERSION >> /tmp/xterm_version\n")
      machine.wait_for_file("/tmp/xterm_version")
      assert "${pkgs.xterm.version}" in machine.succeed("cat /tmp/xterm_version")
      machine.screenshot("window")
    '';
  }
)
