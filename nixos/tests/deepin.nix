import ./make-test-python.nix ({ pkgs, ...} :
{
  name = "deepin";

  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ romildo ];
  };

  machine = { ... }:
  {
    imports = [ ./common/user-account.nix ];
    services.xserver.enable = true;
    services.xserver.desktopManager.deepin.enable = true;
    services.xserver.displayManager.lightdm = {
      enable = true;
      autoLogin = {
        enable = true;
        user = "alice";
      };
    };
    hardware.pulseaudio.enable = true; # needed for the factl test, /dev/snd/* exists without them but udev doesn't care then
    virtualisation.diskSize = 1024;
    virtualisation.memorySize = 1024;
    environment.systemPackages = [ pkgs.xdotool ];
    services.acpid.enable = true;
    networking.useNetworkd = true;
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    with subtest("Ensure X starts"):
        machine.wait_for_x()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")

    with subtest("Check that logging in has given the user ownership of devices"):
        machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

    with subtest("Effect mode"):
        # geeqie: image viewer which shows coordinate of pixels
        machine.wait_for_text("Friendly Reminder")  # Effect/Normal mode
        machine.screenshot("deepin1")
        machine.succeed("xdotool mousemove 512 480 click 1")  # Normal mode

    with subtest("Open Deepin Terminal"):
        machine.screenshot("deepin2a")
        machine.sleep(60)
        machine.screenshot("deepin2b")
        machine.sleep(60)
        machine.screenshot("deepin2c")
        # machine.sleep(60)
        # machine.screenshot("deepin2d")
        # machine.sleep(60)
        # machine.screenshot("deepin2e")
        # machine.sleep(60)
        # machine.screenshot("deepin2f")
        # machine.sleep(60)
        # machine.screenshot("deepin2g")
        # machine.sleep(60)
        # machine.screenshot("deepin2h")
        # machine.sleep(60)
        # machine.screenshot("deepin2i")
        # machine.sleep(60)
        # machine.screenshot("deepin2j")
        # machine.sleep(60)
        # machine.screenshot("deepin2k")
        # machine.sleep(60)
        # machine.screenshot("deepin2l")
        # machine.sleep(60)
        # machine.screenshot("deepin2m")
        # machine.sleep(60)
        # machine.screenshot("deepin2n")
        # machine.sleep(60)
        # machine.screenshot("deepin2o")
        # machine.sleep(60)
        # machine.screenshot("deepin2p")
        # machine.sleep(60)
        # machine.screenshot("deepin2q")
        # machine.sleep(60)
        # machine.screenshot("deepin2r")
        # machine.sleep(60)
        # machine.screenshot("deepin2s")
        # machine.sleep(60)
        # machine.screenshot("deepin2t")
        # machine.sleep(60)
        # machine.screenshot("deepin2u")
        # machine.sleep(60)
        # machine.screenshot("deepin2v")
        machine.succeed("deepin-terminal &")
        machine.sleep(20)
        machine.send_chars("ls --color -alF\n")
        machine.sleep(20)
        machine.screenshot("deepin3")
  '';
})
