{ lib, pkgs, ... }:
let
  # called as <terminal> <yazi> --chooser-file <out>
  fakeTerminal = pkgs.writeShellScript "fake-terminal" ''
    echo /home/alice/picked.txt > "$3"
  '';
in
{
  name = "xdg-desktop-portal-termfilepickers";
  meta.maintainers = with lib.maintainers; [ anish ];

  nodes.machine = {
    users.users.alice = {
      isNormalUser = true;
      linger = true;
      uid = 1000;
    };

    xdg.portal.termfilepickers = {
      enable = true;
      settings.terminal_command = [ "${fakeTerminal}" ];
    };
  };

  testScript = ''
    machine.wait_for_unit("user@1000.service")
    machine.systemctl("start xdg-desktop-portal-termfilepickers.service", "alice")

    out = machine.wait_until_succeeds("""
      runuser -u alice -- env DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
        ${lib.getExe' pkgs.glib "gdbus"} call --session \
          --dest org.freedesktop.impl.portal.desktop.termfilepickers \
          --object-path /org/freedesktop/portal/desktop \
          --method org.freedesktop.impl.portal.FileChooser.OpenFile \
          /org/freedesktop/portal/desktop/request/1_1/test "'test'" '""' "'Open'" '{}'
    """)
    t.assertIn("file:///home/alice/picked.txt", out)
  '';
}
