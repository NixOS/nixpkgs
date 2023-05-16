<<<<<<< HEAD
import ../make-test-python.nix ({ lib, ... }:
rec {
  name = "fcitx5";
  meta.maintainers = with lib.maintainers; [ nevivurn ];

=======
import ../make-test-python.nix ({ pkgs, ... }:
# copy_from_host works only for store paths
rec {
  name = "fcitx5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nodes.machine = { pkgs, ... }:
  {
    imports = [
      ../common/user-account.nix
    ];

    environment.systemPackages = [
      # To avoid clashing with xfce4-terminal
      pkgs.alacritty
    ];

    services.xserver = {
      enable = true;

      displayManager = {
        lightdm.enable = true;
        autoLogin = {
          enable = true;
          user = "alice";
        };
      };

      desktopManager.xfce.enable = true;
    };

    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = [
<<<<<<< HEAD
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
=======
        pkgs.fcitx5-m17n
        pkgs.fcitx5-chinese-addons
      ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  testScript = { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      xauth         = "${user.home}/.Xauthority";
<<<<<<< HEAD
    in
      ''
            start_all()

            machine.wait_for_x()
            machine.wait_for_file("${xauth}")
            machine.succeed("xauth merge ${xauth}")
            machine.sleep(5)

            machine.succeed("su - ${user.name} -c 'kill $(pgrep fcitx5)'")
            machine.sleep(1)

            machine.succeed("su - ${user.name} -c 'alacritty >&2 &'")
            machine.succeed("su - ${user.name} -c 'fcitx5 >&2 &'")
=======
      fcitx_confdir = "${user.home}/.config/fcitx5";
    in
      ''
            # We need config files before login session
            # So copy first thing

            # Point and click would be expensive,
            # So configure using files
            machine.copy_from_host(
                "${./profile}",
                "${fcitx_confdir}/profile",
            )
            machine.copy_from_host(
                "${./config}",
                "${fcitx_confdir}/config",
            )

            start_all()

            machine.wait_for_file("${xauth}}")
            machine.succeed("xauth merge ${xauth}")

            machine.sleep(5)

            machine.succeed("su - ${user.name} -c 'alacritty&'")
            machine.succeed("su - ${user.name} -c 'fcitx5&'")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            machine.sleep(10)

            ### Type on terminal
            machine.send_chars("echo ")
            machine.sleep(1)

            ### Start fcitx Unicode input
            machine.send_key("ctrl-alt-shift-u")
<<<<<<< HEAD
=======
            machine.sleep(5)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
            machine.send_chars("gggh ")
            machine.sleep(1)

            ### Switch to Hangul
            machine.send_key("alt-shift")
            machine.sleep(1)

            ### Enter 한
            machine.send_chars("gks")
=======
            machine.send_chars("gggh")
            machine.sleep(1)
            machine.send_key("\n")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            machine.sleep(1)

            ### Switch to Harvard Kyoto
            machine.send_key("alt-shift")
            machine.sleep(1)

            ### Enter क
<<<<<<< HEAD
            machine.send_chars("ka")
            machine.sleep(1)

            ### Switch to Mozc
            machine.send_key("alt-shift")
            machine.sleep(1)

            ### Enter か
            machine.send_chars("ka\n")
            machine.sleep(1)

=======
            machine.send_chars("ka ")
            machine.sleep(1)

            machine.send_key("alt-shift")
            machine.sleep(1)

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            ### Turn off Fcitx
            machine.send_key("ctrl-spc")
            machine.sleep(1)

            ### Redirect typed characters to a file
            machine.send_chars(" > fcitx_test.out\n")
            machine.sleep(1)
            machine.screenshot("terminal_chars")

            ### Verify that file contents are as expected
            file_content = machine.succeed("cat ${user.home}/fcitx_test.out")
<<<<<<< HEAD
            assert file_content == "☺一下한कか\n"
      ''
=======
            assert file_content == "☺一下क\n"
            ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ;
})
