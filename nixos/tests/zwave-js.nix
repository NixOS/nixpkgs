{ lib, ... }:

{
  name = "zwave-js";
  meta.maintainers = with lib.maintainers; [ graham33 ];

  nodes = {
    machine = {
      # show that 0400 secrets can be used by the DynamicUser; ideally
      # this would be an out-of-store file, e.g. /run/secrets/jwavejs/secrets.json
      environment.etc."zwavejs/secrets.json" = {
        mode = "0400";
        text = builtins.toJSON {
          securityKeys.S0_Legacy = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        };
      };
      services.zwave-js = {
        enable = true;
        serialPort = "/dev/null";
        extraFlags = [ "--mock-driver" ];
        secretsConfigFile = "/etc/zwavejs/secrets.json";
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("zwave-js.service")
    machine.wait_for_open_port(3000)
    machine.wait_until_succeeds("journalctl --since -1m --unit zwave-js --grep 'ZwaveJS server listening'")
  '';
}
