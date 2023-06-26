import ../make-test-python.nix ({ lib, ... }:
rec {
  name = "fcitx5";
  meta.maintainers = with lib.maintainers; [ nevivurn ];

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
        pkgs.fcitx5-chinese-addons
        pkgs.fcitx5-hangul
        pkgs.fcitx5-m17n
        pkgs.fcitx5-mozc
      ];
    };
  };

  testScript = { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      xauth         = "${user.home}/.Xauthority";
      fcitx_confdir = "${user.home}/.config/fcitx5";
    in
      ''
            start_all()

            machine.wait_for_x()
            machine.wait_for_file("${xauth}")
            machine.succeed("xauth merge ${xauth}")
            machine.sleep(5)

            machine.succeed("su - ${user.name} -c 'kill $(pgrep fcitx5)'")
            machine.sleep(1)

            machine.copy_from_host(
                "${./profile}",
                "${fcitx_confdir}/profile",
            )
            machine.copy_from_host(
                "${./config}",
                "${fcitx_confdir}/config",
            )

            machine.succeed("su - ${user.name} -c 'alacritty >&2 &'")
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
      ''
  ;
})
