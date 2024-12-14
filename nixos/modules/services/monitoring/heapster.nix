{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.heapster;
in
{
  options.services.heapster = {
    enable = lib.mkEnableOption "Heapster monitoring";

    source = lib.mkOption {
      description = "Heapster metric source";
      example = "kubernetes:https://kubernetes.default";
      type = lib.types.str;
    };

    sink = lib.mkOption {
      description = "Heapster metic sink";
      example = "influxdb:http://localhost:8086";
      type = lib.types.str;
    };

    extraOpts = lib.mkOption {
      description = "Heapster extra options";
      default = "";
      type = lib.types.separatedString " ";
    };

    package = lib.mkPackageOption pkgs "heapster" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.heapster = {
      wantedBy = [ "multi-user.target" ];
      after = [
        "cadvisor.service"
        "kube-apiserver.service"
      ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/heapster --source=${cfg.source} --sink=${cfg.sink} ${cfg.extraOpts}";
        User = "heapster";
      };
    };

    users.users.heapster = {
      isSystemUser = true;
      group = "heapster";
      description = "Heapster user";
    };
    users.groups.heapster = { };
  };
}
