import ../make-test-python.nix (
  {
    pkgs, ...
  }:
    # copy_from_host works only for store paths
    rec {
        name = "fcitx";
        meta.broken = true; # takes hours to time out since October 2021
        nodes.machine =
        {
          pkgs,
          ...
        }:
          {

            imports = [
              ../common/user-account.nix
            ];

            environment.systemPackages = [
              # To avoid clashing with xfce4-terminal
              pkgs.alacritty
            ];


            services.xserver =
            {
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

            i18n = {
              inputMethod = {
                enabled = "fcitx";
                fcitx.engines = [
                  pkgs.fcitx-engines.m17n
                  pkgs.fcitx-engines.table-extra
                ];
              };
            };
          }
        ;

        testScript = { nodes, ... }:
        let
            user = nodes.machine.config.users.users.alice;
            userName      = user.name;
            userHome      = user.home;
            xauth         = "${userHome}/.Xauthority";
            fcitx_confdir = "${userHome}/.config/fcitx";
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

            machine.wait_for_file("${xauth}")
            machine.succeed("xauth merge ${xauth}")

            machine.sleep(5)

            machine.succeed("su - ${userName} -c 'alacritty&'")
            machine.succeed("su - ${userName} -c 'fcitx&'")
            machine.sleep(10)

            ### Type on terminal
            machine.send_chars("echo ")
            machine.sleep(1)

            ### Start fcitx Unicode input
            machine.send_key("ctrl-alt-shift-u")
            machine.sleep(5)
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

            ### Default zhengma, enter 一下
            machine.send_chars("a2")
            machine.sleep(1)

            ### Switch to Harvard Kyoto
            machine.send_key("alt-shift")
            machine.sleep(1)

            ### Enter क
            machine.send_chars("ka ")
            machine.sleep(1)

            machine.send_key("alt-shift")
            machine.sleep(1)

            ### Turn off Fcitx
            machine.send_key("ctrl-spc")
            machine.sleep(1)

            ### Redirect typed characters to a file
            machine.send_chars(" > fcitx_test.out\n")
            machine.sleep(1)
            machine.screenshot("terminal_chars")

            ### Verify that file contents are as expected
            file_content = machine.succeed("cat ${userHome}/fcitx_test.out")
            assert file_content == "☺一下क\n"
            ''
    ;
  }
)
