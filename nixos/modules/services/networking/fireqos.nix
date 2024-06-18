{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fireqos;
  fireqosConfig = pkgs.writeText "fireqos.conf" "${cfg.config}";
in {
  options.services.fireqos = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, FireQOS will be launched with the specified
        configuration given in `config`.
      '';
    };

    config = mkOption {
      type = types.str;
      default = "";
      example = ''
        interface wlp3s0 world-in input rate 10mbit ethernet
          class web commit 50kbit
            match tcp ports 80,443

        interface wlp3s0 world-out input rate 10mbit ethernet
          class web commit 50kbit
            match tcp ports 80,443
      '';
      description = ''
        The FireQOS configuration goes here.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.fireqos = {
      description = "FireQOS";
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.firehol}/bin/fireqos start ${fireqosConfig}";
        ExecStop = [
          "${pkgs.firehol}/bin/fireqos stop"
          "${pkgs.firehol}/bin/fireqos clear_all_qos"
        ];
      };
    };
  };
}
