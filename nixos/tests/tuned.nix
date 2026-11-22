{ pkgs, ... }:

{
  name = "tuned";
  meta = { inherit (pkgs.tuned.meta) maintainers; };

  nodes.machine = {
    imports = [ ./common/x11.nix ];

    services.tuned = {
      enable = true;

      profiles = {
        test-profile = {
          sysctls = {
            type = "sysctl";
            replace = true;

            "net.core.rmem_default" = 262144;
            "net.core.wmem_default" = 262144;
          };
        };
      };
    };
  };

  enableOCR = true;

  testScript = ''
    with subtest("Wait for service startup"):
      machine.wait_for_x()
      machine.wait_for_unit("tuned.service")
      machine.wait_for_unit("tuned-ppd.service")

    with subtest("Get service status"):
      machine.succeed("systemctl status tuned.service")

    # NOTE(@getchoo): `pkgs.tuned` provides its own `tuned.conf` for tmpfiles.d
    # A naming conflict with it and a `systemd.tmpfiles.settings` entry appeared in the initial PR for this module
    # This breaks the GUI in some cases, and it was annoying to figure out. Make sure it doesn't happen again!
    with subtest("Ensure systemd-tmpfiles paths are configured"):
      machine.succeed("systemd-tmpfiles --cat-config | grep '/etc/tuned/profiles'")
      machine.succeed("systemd-tmpfiles --cat-config | grep '/run/tuned'")

    with subtest("Test GUI"):
      machine.execute("tuned-gui >&2 &")
      machine.wait_for_window("tuned")
      machine.wait_for_text("Start TuneD Daemon")
      machine.screenshot("gui")
  '';
}
