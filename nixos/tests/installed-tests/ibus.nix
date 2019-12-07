{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.ibus;

  testConfig = {
    i18n.inputMethod.enabled = "ibus";
  };

  preTestScript = ''
    # ibus has ibus-desktop-testing-runner but it tries to manage desktop session so we just spawn ibus-daemon ourselves
    machine.succeed("ibus-daemon --daemonize --verbose")
  '';

  withX11 = true;

  # TODO: ibus-daemon is currently crashing or something
  # maybe make ibus systemd service that auto-restarts?
  meta.broken = true;
}
