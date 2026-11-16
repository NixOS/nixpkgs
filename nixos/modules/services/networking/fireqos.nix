{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fireqos;
  fireqosConfig = pkgs.writeText "fireqos.conf" cfg.config;
in
{
  options.services.fireqos = {
    enable = lib.mkEnableOption "FireQOS";

    config = lib.mkOption {
      type = lib.types.lines;
      example = ''
        interface wlp3s0 world-in input rate 10mbit ethernet
          class web commit 50kbit
            match tcp ports 80,443

        interface wlp3s0 world-out input rate 10mbit ethernet
          class web commit 50kbit
            match tcp ports 80,443
      '';
      description = ''
        The FireQOS configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fireqos = {
      description = "FireQOS";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
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
