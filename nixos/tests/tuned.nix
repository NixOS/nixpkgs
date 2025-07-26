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

    with subtest("Test GUI"):
      machine.execute("tuned-gui >&2 &")
      machine.wait_for_window("tuned")
      machine.wait_for_text("Start TuneD Daemon")
      machine.screenshot("gui")
  '';
}
