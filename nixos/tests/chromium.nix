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

mapAttrs (channel: chromiumPkg: makeTest rec {
  name = "chromium-${channel}";
  meta = {
    maintainers = with maintainers; [ aszlig primeos ];
    # https://github.com/NixOS/hydra/issues/591#issuecomment-435125621
    inherit (chromiumPkg.meta) timeout;
  };

  enableOCR = true;

  user = "alice";

  machine.imports = [ ./common/user-account.nix ./common/x11.nix ];
  machine.virtualisation.memorySize = 2047;
  machine.test-support.displayManager.auto.user = user;
  machine.environment.systemPackages = [ chromiumPkg ];

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


    def get_browser_binary():
        """Returns the name of the browser binary."""
        pname = "${getName chromiumPkg.name}"
        if pname.find("chromium") != -1:
            return "chromium"  # Same name for all channels and ungoogled-chromium
        if pname == "google-chrome":
            return "google-chrome-stable"
        if pname == "google-chrome-dev":
            return "google-chrome-unstable"
        # For google-chrome-beta and as fallback:
        return pname


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
    def test_new_win(description):
        create_new_win()
        with machine.nested(description):
            yield
        # Close the newly created window:
        machine.send_key("ctrl-w")


    machine.wait_for_x()

    url = "file://${startupHTML}"
    machine.succeed(ru(f'ulimit -c unlimited; "{get_browser_binary()}" "{url}" & disown'))

    if get_browser_binary().startswith("google-chrome"):
        # Need to click away the first window:
        machine.wait_for_text("Make Google Chrome the default browser")
        machine.screenshot("google_chrome_default_browser_prompt")
        machine.send_key("ret")

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

    with test_new_win("check sandbox"):
        machine.succeed(
            ru(
                "${xdo "type-url" ''
                  search --sync --onlyvisible --name "New Tab"
                  windowfocus --sync
                  type --delay 1000 "chrome://sandbox"
                ''}"
            )
        )

        machine.succeed(
            ru(
                "${xdo "submit-url" ''
                  search --sync --onlyvisible --name "New Tab"
                  windowfocus --sync
                  key --delay 1000 Return
                ''}"
            )
        )

        machine.screenshot("sandbox_info")

        machine.succeed(
            ru(
                "${xdo "find-window" ''
                  search --sync --onlyvisible --name "Sandbox Status"
                  windowfocus --sync
                ''}"
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
                "echo void | ${pkgs.xclip}/bin/xclip -i"
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

    machine.shutdown()
  '';
}) channelMap
