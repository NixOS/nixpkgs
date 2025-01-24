import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "ntpd";

    meta = {
      maintainers = with lib.maintainers; [ pyrox0 ];
    };

    nodes.machine = {
      services.ntp = {
        enable = true;
      };
    };

    testScript = ''
      start_all()

      machine.wait_for_unit('ntpd.service')
      machine.wait_for_console_text('Listen normally on 10 eth*')
      machine.succeed('systemctl is-active ntpd.service')
      machine.succeed('ntpq -p')
    '';
  }
)
