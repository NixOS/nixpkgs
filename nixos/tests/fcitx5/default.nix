import ../make-test-python.nix (
  { lib, ... }:
  rec {
    name = "fcitx5";
    meta.maintainers = with lib.maintainers; [ nevivurn ];

    nodes.machine =
      { pkgs, ... }:
      {
        imports = [
          ../common/user-account.nix
        ];

        environment.systemPackages = [
          # To avoid clashing with xfce4-terminal
          pkgs.alacritty
        ];

        services.displayManager.autoLogin = {
          enable = true;
          user = "alice";
        };

        services.xserver = {
          enable = true;
          displayManager.lightdm.enable = true;
          desktopManager.xfce.enable = true;
        };

        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";
          fcitx5.addons = [
            pkgs.fcitx5-chinese-addons
            pkgs.fcitx5-hangul
            pkgs.fcitx5-m17n
            pkgs.fcitx5-mozc
          ];
          fcitx5.settings = {
            globalOptions = {
              "Hotkey"."EnumerateSkipFirst" = "False";
              "Hotkey/TriggerKeys"."0" = "Control+space";
              "Hotkey/EnumerateForwardKeys"."0" = "Alt+Shift_L";
              "Hotkey/EnumerateBackwardKeys"."0" = "Alt+Shift_R";
            };
            inputMethod = {
              "GroupOrder" = {
                "0" = "NixOS_test";
              };
              "Groups/0" = {
                "Default Layout" = "us";
                "DefaultIM" = "wbx";
                "Name" = "NixOS_test";
              };
              "Groups/0/Items/0" = {
                "Name" = "keyboard-us";
              };
              "Groups/0/Items/1" = {
                "Layout" = "us";
                "Name" = "wbx";
              };
              "Groups/0/Items/2" = {
                "Layout" = "us";
                "Name" = "hangul";
              };
              "Groups/0/Items/3" = {
                "Layout" = "us";
                "Name" = "m17n_sa_harvard-kyoto";
              };
              "Groups/0/Items/4" = {
                "Layout" = "us";
                "Name" = "mozc";
              };
            };
          };
        };
      };

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
        xauth = "${user.home}/.Xauthority";
      in
      ''
        start_all()

        machine.wait_for_x()
        machine.wait_for_file("${xauth}")
        machine.succeed("xauth merge ${xauth}")
        machine.sleep(5)

        machine.wait_until_succeeds("pgrep fcitx5")
        machine.succeed("su - ${user.name} -c 'kill $(pgrep fcitx5)'")
        machine.sleep(1)

        machine.succeed("su - ${user.name} -c 'alacritty >&2 &'")
        machine.wait_for_window("alice@machine")

        machine.succeed("su - ${user.name} -c 'fcitx5 >&2 &'")
        machine.sleep(10)

        ### Type on terminal
        machine.send_chars("echo ")
        machine.sleep(1)

        ### Start fcitx Unicode input
        machine.send_key("ctrl-alt-shift-u")
        machine.sleep(1)

        ### Search for smiling face
        machine.send_chars("smil")
        machine.sleep(1)

        ### Navigate to the second one
        machine.send_key("tab")
        machine.sleep(1)

        ### Choose it
        machine.send_key("\n")
        machine.sleep(1)

        ### Start fcitx language input
        machine.send_key("ctrl-spc")
        machine.sleep(1)

        ### Default wubi, enter 一下
        machine.send_chars("gggh ")
        machine.sleep(1)

        ### Switch to Hangul
        machine.send_key("alt-shift")
        machine.sleep(1)

        ### Enter 한
        machine.send_chars("gks")
        machine.sleep(1)

        ### Switch to Harvard Kyoto
        machine.send_key("alt-shift")
        machine.sleep(1)

        ### Enter क
        machine.send_chars("ka")
        machine.sleep(1)

        ### Switch to Mozc
        machine.send_key("alt-shift")
        machine.sleep(1)

        ### Enter か
        machine.send_chars("ka\n")
        machine.sleep(1)

        ### Turn off Fcitx
        machine.send_key("ctrl-spc")
        machine.sleep(1)

        ### Redirect typed characters to a file
        machine.send_chars(" > fcitx_test.out\n")
        machine.sleep(1)
        machine.screenshot("terminal_chars")

        ### Verify that file contents are as expected
        file_content = machine.succeed("cat ${user.home}/fcitx_test.out")
        assert file_content == "☺一下한कか\n"
      '';
  }
)
