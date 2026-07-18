{ config, lib, ... }:
let
  xdotool = lib.getExe config.node.pkgs.xdotool;
in
{
  name = "firefox_decrypt";

  meta = {
    maintainers = with lib.maintainers; [ schnusch ];
  };

  containers.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];
      programs.firefox.enable = true;
      environment.systemPackages = [ pkgs.firefox_decrypt ];
    };

  enableOCR = true;

  testScript = ''
    import csv
    import io
    import random
    import shlex
    import string

    def send_x11_key(key: str) -> None:
        machine.succeed(f"${xdotool} key --clearmodifiers {shlex.quote(key)}")


    def type_x11_text(text: str) -> None:
        machine.succeed(
            f"${xdotool} type --clearmodifiers --delay 10 -- {shlex.quote(text)}"
        )


    machine.wait_for_x()

    expected: dict[str, str] = {
        "url": "http://localhost",
        "user": "user",
        "password": "".join(random.choices(string.ascii_letters + string.digits, k=32)),
    }

    machine.execute("firefox about:logins >&2 &")

    # press "Add password" button
    # "Search Passwords" is not found by OCR, probably due to too low contrast.
    machine.wait_for_text("No passwords saved")
    for key in ("Tab", "Return"):
        send_x11_key(key)

    # add a new password entry
    machine.wait_for_text("Add password")
    for text, control in [
        (expected["url"], "Tab"),
        (expected["user"], "Tab"),
        (expected["password"], "Return"),
    ]:
        with machine.nested(f"typing {repr(text)}"):
            type_x11_text(text)
        send_x11_key(control)

    # "Remove" button for our new entry appeared
    machine.wait_for_text("Remove")

    # close Firefox
    send_x11_key("ctrl+q")
    machine.wait_for_text(r"Quit Firefox or close current tab\?")
    send_x11_key("Return")

    # extract Firefox logins
    credentials = list(
        csv.DictReader(
            io.StringIO(
                machine.succeed("firefox-decrypt -f csv ~/.config/mozilla/firefox"),
                newline="",
            ),
            delimiter=";",
        )
    )
    assert expected in credentials, f"expected {expected!r} in {credentials!r}"
  '';
}
