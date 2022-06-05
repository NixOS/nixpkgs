{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
, channelMap ? { # Maps "channels" to packages
    stable        = pkgs.chromium;
    beta          = pkgs.chromiumBeta;
    dev           = pkgs.chromiumDev;
    ungoogled     = pkgs.ungoogled-chromium;
    chrome-stable = pkgs.google-chrome;
    chrome-beta   = pkgs.google-chrome-beta;
    chrome-dev    = pkgs.google-chrome-dev;
  }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  user = "alice";

  startupHTML = pkgs.writeText "chromium-startup.html" ''
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    <title>Chromium startup notifier</title>
    </head>
    <body onload="javascript:document.title='startup done'">
      <img src="file://${pkgs.fetchurl {
        url = "https://nixos.org/logo/nixos-hex.svg";
        sha256 = "07ymq6nw8kc22m7kzxjxldhiq8gzmc7f45kq2bvhbdm0w5s112s4";
      }}" />
    </body>
    </html>
  '';
in

mapAttrs (channel: chromiumPkg: makeTest {
  name = "chromium-${channel}";
  meta = {
    maintainers = with maintainers; [ aszlig primeos ];
    # https://github.com/NixOS/hydra/issues/591#issuecomment-435125621
    inherit (chromiumPkg.meta) timeout;
  };

  enableOCR = true;

  nodes.machine = { ... }: {
    imports = [ ./common/user-account.nix ./common/x11.nix ];
    virtualisation.memorySize = 2047;
    test-support.displayManager.auto.user = user;
    environment = {
      systemPackages = [ chromiumPkg ];
      variables."XAUTHORITY" = "/home/alice/.Xauthority";
    };
  };

  testScript = let
    xdo = name: text: let
      xdoScript = pkgs.writeText "${name}.xdo" text;
    in "${pkgs.xdotool}/bin/xdotool ${xdoScript}";
  in ''
    import shlex
    import re
    from contextlib import contextmanager


    # Run as user alice
    def ru(cmd):
        return "su - ${user} -c " + shlex.quote(cmd)


    def launch_browser():
        """Launches the web browser with the correct options."""
        # Determine the name of the binary:
        pname = "${getName chromiumPkg.name}"
        if pname.find("chromium") != -1:
            binary = "chromium"  # Same name for all channels and ungoogled-chromium
        elif pname == "google-chrome":
            binary = "google-chrome-stable"
        elif pname == "google-chrome-dev":
            binary = "google-chrome-unstable"
        else:  # For google-chrome-beta and as fallback:
            binary = pname
        # Add optional CLI options:
        options = []
        major_version = "${versions.major (getVersion chromiumPkg.name)}"
        if major_version > "95" and not pname.startswith("google-chrome"):
            # Workaround to avoid a GPU crash:
            options.append("--use-gl=swiftshader")
        # Launch the process:
        options.append("file://${startupHTML}")
        machine.succeed(ru(f'ulimit -c unlimited; {binary} {shlex.join(options)} >&2 & disown'))
        if binary.startswith("google-chrome"):
            # Need to click away the first window:
            machine.wait_for_text("Make Google Chrome the default browser")
            machine.screenshot("google_chrome_default_browser_prompt")
            machine.send_key("ret")


    def create_new_win():
        """Creates a new Chromium window."""
        with machine.nested("Creating a new Chromium window"):
            machine.wait_until_succeeds(
                ru(
                    "${xdo "create_new_win-select_main_window" ''
                      search --onlyvisible --name "startup done"
                      windowfocus --sync
                      windowactivate --sync
                    ''}"
                )
            )
            machine.send_key("ctrl-n")
            # Wait until the new window appears:
            machine.wait_until_succeeds(
                ru(
                    "${xdo "create_new_win-wait_for_window" ''
                      search --onlyvisible --name "New Tab"
                      windowfocus --sync
                      windowactivate --sync
                    ''}"
                )
            )


    def close_new_tab_win():
        """Closes the Chromium window with the title "New Tab"."""
        machine.wait_until_succeeds(
            ru(
                "${xdo "close_new_tab_win-select_main_window" ''
                  search --onlyvisible --name "New Tab"
                  windowfocus --sync
                  windowactivate --sync
                ''}"
            )
        )
        machine.send_key("ctrl-w")
        # Wait until the closed window disappears:
        machine.wait_until_fails(
            ru(
                "${xdo "close_new_tab_win-wait_for_close" ''
                  search --onlyvisible --name "New Tab"
                ''}"
            )
        )


    @contextmanager
    def test_new_win(description, url, window_name):
        create_new_win()
        machine.wait_for_window("New Tab")
        machine.send_chars(f"{url}\n")
        machine.wait_for_window(window_name)
        machine.screenshot(description)
        machine.succeed(
            ru(
                "${xdo "copy-all" ''
                  key --delay 1000 Ctrl+a Ctrl+c
                ''}"
            )
        )
        clipboard = machine.succeed(
            ru("${pkgs.xclip}/bin/xclip -o")
        )
        print(f"{description} window content:\n{clipboard}")
        with machine.nested(description):
            yield clipboard
        # Close the newly created window:
        machine.send_key("ctrl-w")


    machine.wait_for_x()

    launch_browser()

    machine.wait_for_text("startup done")
    machine.wait_until_succeeds(
        ru(
            "${xdo "check-startup" ''
              search --sync --onlyvisible --name "startup done"
              # close first start help popup
              key -delay 1000 Escape
              windowfocus --sync
              windowactivate --sync
            ''}"
        )
    )

    create_new_win()
    # Optional: Wait for the new tab page to fully load before taking the screenshot:
    machine.wait_for_text("Web Store")
    machine.screenshot("empty_windows")
    close_new_tab_win()

    machine.screenshot("startup_done")

    with test_new_win("sandbox_info", "chrome://sandbox", "Sandbox Status") as clipboard:
        filters = [
            "layer 1 sandbox.*namespace",
            "pid namespaces.*yes",
            "network namespaces.*yes",
            "seccomp.*sandbox.*yes",
            "you are adequately sandboxed",
        ]
        if not all(
            re.search(filter, clipboard, flags=re.DOTALL | re.IGNORECASE)
            for filter in filters
        ):
            assert False, f"sandbox not working properly: {clipboard}"

        machine.sleep(1)
        machine.succeed(
            ru(
                "${xdo "find-window-after-copy" ''
                  search --onlyvisible --name "Sandbox Status"
                ''}"
            )
        )

        clipboard = machine.succeed(
            ru(
                "echo void | ${pkgs.xclip}/bin/xclip -i >&2"
            )
        )
        machine.succeed(
            ru(
                "${xdo "copy-sandbox-info" ''
                  key --delay 1000 Ctrl+a Ctrl+c
                ''}"
            )
        )

        clipboard = machine.succeed(
            ru("${pkgs.xclip}/bin/xclip -o")
        )
        if not all(
            re.search(filter, clipboard, flags=re.DOTALL | re.IGNORECASE)
            for filter in filters
        ):
            assert False, f"copying twice in a row does not work properly: {clipboard}"

        machine.screenshot("after_copy_from_chromium")


    with test_new_win("gpu_info", "chrome://gpu", "chrome://gpu"):
        # To check the text rendering (catches regressions like #131074):
        machine.wait_for_text("Graphics Feature Status")


    with test_new_win("version_info", "chrome://version", "About Version") as clipboard:
        filters = [
            r"${chromiumPkg.version} \(Official Build",
        ]
        if not all(
            re.search(filter, clipboard) for filter in filters
        ):
            assert False, "Version info not correct."


    machine.shutdown()
  '';
}) channelMap
