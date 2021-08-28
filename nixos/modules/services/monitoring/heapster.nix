{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.heapster;
in {
  options.services.heapster = {
    enable = mkOption {
      description = "Whether to enable heapster monitoring";
      default = false;
      type = types.bool;
    };

    source = mkOption {
      description = "Heapster metric source";
      example = "kubernetes:https://kubernetes.default";
      type = types.str;
    };

    sink = mkOption {
      description = "Heapster metic sink";
      example = "influxdb:http://localhost:8086";
      type = types.str;
    };

    extraOpts = mkOption {
      description = "Heapster extra options";
      default = "";
      type = types.separatedString " ";
    };

    package = mkOption {
      description = "Package to use by heapster";
      default = pkgs.heapster;
      defaultText = "pkgs.heapster";
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.heapster = {
      wantedBy = ["multi-user.target"];
      after = ["cadvisor.service" "kube-apiserver.service"];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/heapster --source=${cfg.source} --sink=${cfg.sink} ${cfg.extraOpts}";
        User = "heapster";
      };
    };

    users.users.heapster = {
      uid = config.ids.uids.heapster;
      description = "Heapster user";
    };
  };
}
