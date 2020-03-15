{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
, channelMap ? {
    stable = pkgs.chromium;
    beta   = pkgs.chromiumBeta;
    dev    = pkgs.chromiumDev;
  }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

mapAttrs (channel: chromiumPkg: makeTest rec {
  name = "chromium-${channel}";
  meta = {
    maintainers = with maintainers; [ aszlig ];
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
        url = "http://nixos.org/logo/nixos-hex.svg";
        sha256 = "07ymq6nw8kc22m7kzxjxldhiq8gzmc7f45kq2bvhbdm0w5s112s4";
      }}" />
    </body>
    </html>
  '';

  testScript = let
    xdo = name: text: let
      xdoScript = pkgs.writeText "${name}.xdo" text;
    in "${pkgs.xdotool}/bin/xdotool '${xdoScript}'";
  in ''
    import shlex
    from contextlib import contextmanager, _GeneratorContextManager


    # Run as user alice
    def ru(cmd):
        return "su - ${user} -c " + shlex.quote(cmd)


    def create_new_win():
        with machine.nested("Creating a new Chromium window"):
            machine.execute(
                ru(
                    "${xdo "new-window" ''
                      search --onlyvisible --name "startup done"
                      windowfocus --sync
                      windowactivate --sync
                    ''}"
                )
            )
            machine.execute(
                ru(
                    "${xdo "new-window" ''
                      key Ctrl+n
                    ''}"
                )
            )


    def close_win():
        def try_close(_):
            machine.execute(
                ru(
                    "${xdo "close-window" ''
                      search --onlyvisible --name "new tab"
                      windowfocus --sync
                      windowactivate --sync
                    ''}"
                )
            )
            machine.execute(
                ru(
                    "${xdo "close-window" ''
                      key Ctrl+w
                    ''}"
                )
            )
            for _ in range(1, 20):
                status, out = machine.execute(
                    ru(
                        "${xdo "wait-for-close" ''
                          search --onlyvisible --name "new tab"
                        ''}"
                    )
                )
                if status != 0:
                    return True
                machine.sleep(1)
                return False

        retry(try_close)


    def wait_for_new_win():
        ret = False
        with machine.nested("Waiting for new Chromium window to appear"):
            for _ in range(1, 20):
                status, out = machine.execute(
                    ru(
                        "${xdo "wait-for-window" ''
                          search --onlyvisible --name "new tab"
                          windowfocus --sync
                          windowactivate --sync
                        ''}"
                    )
                )
                if status == 0:
                    ret = True
                    machine.sleep(10)
                    break
                machine.sleep(1)
        return ret


    def create_and_wait_for_new_win():
        for _ in range(1, 3):
            create_new_win()
            if wait_for_new_win():
                return True
        assert False, "new window did not appear within 60 seconds"


    @contextmanager
    def test_new_win(description):
        create_and_wait_for_new_win()
        with machine.nested(description):
            yield
        close_win()


    machine.wait_for_x()

    url = "file://${startupHTML}"
    machine.succeed(ru(f'ulimit -c unlimited; chromium "{url}" & disown'))
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

    create_and_wait_for_new_win()
    machine.screenshot("empty_windows")
    close_win()

    machine.screenshot("startup_done")

    with test_new_win("check sandbox"):
        machine.succeed(
            ru(
                "${xdo "type-url" ''
                  search --sync --onlyvisible --name "new tab"
                  windowfocus --sync
                  type --delay 1000 "chrome://sandbox"
                ''}"
            )
        )

        machine.succeed(
            ru(
                "${xdo "submit-url" ''
                  search --sync --onlyvisible --name "new tab"
                  windowfocus --sync
                  key --delay 1000 Return
                ''}"
            )
        )

        machine.screenshot("sandbox_info")

        machine.succeed(
            ru(
                "${xdo "find-window" ''
                  search --sync --onlyvisible --name "sandbox status"
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
                  search --onlyvisible --name "sandbox status"
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
