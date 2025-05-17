{
  name = "nixos-test-driver.unit-active-state";
  nodes.machine =
    { pkgs, ... }:
    {
      systemd.services.test = {
        serviceConfig.Type = "notify-reload";
        path = [ pkgs.systemd ];
        script = ''
          set -x
          startup() {
            sleep 5
            systemd-notify --ready --status="Started up"
          }

          process() {
            systemd-notify --status="Processing"
            sleep 5
          }

          reload() {
            reloading=0
            systemd-notify --reloading --status="Reloading"
            sleep 5
            systemd-notify --ready --status="Reloaded"
            sleep 5
          }

          stop() {
            systemd-notify --stop --status="Stopping"
            sleep 5
            exit 1
          }

          trap reload SIGHUP
          trap stop SIGTERM

          startup
          while true; do
            process
          done
        '';
      };
    };
  testScript = ''
    machine.wait_for_unit_active_state("test.service", "inactive", timeout=10)
    machine.succeed("systemctl start --no-block test.service")
    machine.wait_for_unit_active_state("test.service", "activating", timeout=10)
    machine.wait_for_unit_active_state("test.service", "active", timeout=10)
    machine.succeed("systemctl reload --no-block test.service")
    machine.wait_for_unit_active_state("test.service", "reloading", timeout=10)
    machine.wait_for_unit_active_state("test.service", "active")
    machine.succeed("systemctl stop --no-block test.service", timeout=10)
    machine.wait_for_unit_active_state("test.service", "deactivating", timeout=10)
    machine.wait_for_unit_active_state("test.service", "failed", timeout=10)
  '';
}
