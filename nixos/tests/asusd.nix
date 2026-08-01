{
  lib,
  pkgs,
  ...
}:

let
  expectedConfig = "declarative fan curves";
  emptyAsusctl = pkgs.runCommand "asusctl-test-package" { } ''
    mkdir -p "$out"
  '';
  checkConfig = pkgs.writeShellScript "check-asusd-config" ''
    ${lib.getExe pkgs.gnugrep} -Fx ${lib.escapeShellArg expectedConfig} /etc/asusd/fan_curves.ron
  '';
in
{
  name = "asusd";

  nodes.machine = {
    services.asusd = {
      enable = true;
      package = emptyAsusctl;
      fanCurvesConfig.text = expectedConfig;
    };

    systemd.services.asusd = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = checkConfig;
        ConfigurationDirectory = "asusd";
        ProtectSystem = "strict";
        ReadWritePaths = [ "/etc/asusd" ];
      };
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("asusd.service")
    machine.succeed("test -f /etc/asusd/fan_curves.ron")
    machine.succeed("test ! -L /etc/asusd/fan_curves.ron")
    machine.succeed("printf '%s' 'runtime fan curves' > /etc/asusd/fan_curves.ron")
    machine.succeed("systemctl restart asusd.service")
    machine.wait_for_unit("asusd.service")
    machine.succeed("grep -Fx '${expectedConfig}' /etc/asusd/fan_curves.ron")
  '';
}
