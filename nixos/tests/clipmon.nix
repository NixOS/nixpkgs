import ./make-test-python.nix ({ lib, ... }: {
  name = "clipmon";
  meta.maintainers = with lib.maintainers; [ ma27 ];
  enableOCR = true;

  nodes.machine = { pkgs, ... }: {
    imports = [ ./common/user-account.nix ];
    services.clipmon.enable = true;
    services.getty.autologinUser = "alice";
    programs.sway.enable = true;
    environment.systemPackages = with pkgs; [ wl-clipboard procps ];
    # see tests.sway
    environment.variables.WLR_RENDERER = "pixman";
    virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];
    programs.bash.loginShellInit = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        mkdir -p ~/.config/sway
        sed s/Mod4/Mod1/ /etc/sway/config > ~/.config/sway/config
        echo "exec systemctl --user start graphical-session.target" >> ~/.config/sway/config
        exec sway
      fi
    '';
    environment.etc."xdg/foot/foot.ini".text = lib.generators.toINI { } {
      main = {
        font = "inconsolata:size=14";
      };
      colors = rec {
        foreground = "000000";
        background = "ffffff";
        regular2 = foreground;
      };
    };
    fonts.fonts = [ pkgs.inconsolata ];
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("multi-user.target")
    machine.wait_for_file("/run/user/1000/wayland-1")
    machine.wait_until_succeeds("pgrep sway")

    machine.send_key("alt-ret")
    machine.wait_for_text("alice@machine")

    machine.send_chars("echo foo | wl-copy -f\n")

    machine.send_key("alt-ret")
    machine.wait_until_succeeds("test $(pgrep foot | wc -l) = 2")
    machine.send_chars('echo "clipboard: $(wl-paste)"' + "\n")
    machine.wait_for_text("clipboard: foo")

    machine.send_key("alt-shift-q")
    machine.send_key("alt-shift-q")

    machine.wait_until_fails("pgrep foot")

    machine.send_key("alt-ret")
    machine.wait_for_text("alice@machine")
    machine.send_chars('echo "clipboard: $(wl-paste)"' + "\n")
    machine.wait_for_text("clipboard: foo")
    machine.screenshot("result")

    machine.shutdown()
  '';
})
