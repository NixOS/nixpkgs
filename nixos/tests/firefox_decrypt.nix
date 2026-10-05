{ lib, ... }:
{
  name = "firefox_decrypt";

  meta = {
    maintainers = with lib.maintainers; [ schnusch ];
  };

  nodes.machine =
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
    import string

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
    for c in ("tab", "\n"):
        machine.send_key(c)

    # add a new password entry
    machine.wait_for_text("Add password")
    for text, control in [
        (expected["url"], "tab"),
        (expected["user"], "tab"),
        (expected["password"], "\n"),
    ]:
        with machine.nested(f"typing {repr(text)}"):
            for c in text:
                machine.send_key(c, log=False)
        machine.send_key(control)

    # "Remove" button for our new entry appeared
    machine.wait_for_text("Remove")

    # close Firefox
    machine.send_key("ctrl-q")
    machine.wait_for_text(r"Quit Firefox or close current tab\?")
    machine.send_key("\n")

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
