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
  commonNode = {
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
        ExecStart = lib.getExe' pkgs.coreutils "true";
        ConfigurationDirectory = "asusd";
        ProtectSystem = "strict";
        ReadWritePaths = [ "/etc/asusd" ];
      };
    };
  };
in
{
  name = "asusd";

  nodes = {
    restored = commonNode;
    mutable = {
      imports = [ commonNode ];
      services.asusd.restoreConfigs = false;
    };
  };

  testScript = ''
    start_all()
    for machine in (restored, mutable):
        machine.wait_for_unit("asusd.service")
        machine.succeed("test -f /etc/asusd/fan_curves.ron")
        machine.succeed("test ! -L /etc/asusd/fan_curves.ron")
        machine.succeed("printf '%s' 'runtime fan curves' > /etc/asusd/fan_curves.ron")
        machine.succeed("systemctl restart asusd.service")
        machine.wait_for_unit("asusd.service")

    restored.succeed("grep -Fx '${expectedConfig}' /etc/asusd/fan_curves.ron")
    mutable.succeed("grep -Fx 'runtime fan curves' /etc/asusd/fan_curves.ron")
  '';
}
