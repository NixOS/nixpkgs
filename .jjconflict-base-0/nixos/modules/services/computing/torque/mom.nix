{ config, pkgs, lib, ... }:
let

  cfg = config.services.torque.mom;
  torque = pkgs.torque;

  momConfig = pkgs.writeText "torque-mom-config" ''
    $pbsserver ${cfg.serverNode}
    $logevent 225
  '';

in
{
  options = {

    services.torque.mom = {
      enable = lib.mkEnableOption "torque computing node";

      serverNode = lib.mkOption {
        type = lib.types.str;
        description = "Hostname running pbs server.";
      };

    };

  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.torque ];

    systemd.services.torque-mom-init = {
      path = with pkgs; [ torque util-linux procps inetutils ];

      script = ''
        pbs_mkdirs -v aux
        pbs_mkdirs -v mom
        hostname > /var/spool/torque/server_name
        cp -v ${momConfig} /var/spool/torque/mom_priv/config
      '';

      serviceConfig.Type = "oneshot";
      unitConfig.ConditionPathExists = "!/var/spool/torque";
    };

    systemd.services.torque-mom = {
      path = [ torque ];

      wantedBy = [ "multi-user.target" ];
      requires = [ "torque-mom-init.service" ];
      after = [ "torque-mom-init.service" "network.target" ];

      serviceConfig = {
        Type = "forking";
        ExecStart = "${torque}/bin/pbs_mom";
        PIDFile = "/var/spool/torque/mom_priv/mom.lock";
      };
    };

  };
}
