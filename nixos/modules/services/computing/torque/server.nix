{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.torque.server;
  torque = pkgs.torque;
in
{
  options = {

    services.torque.server = {

      enable = mkEnableOption "torque server";

    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.torque ];

    systemd.services.torque-server-init = {
      path = with pkgs; [
        torque
        util-linux
        procps
        inetutils
      ];

      script = ''
        tmpsetup=$(mktemp -t torque-XXXX)
        cp -p ${torque}/bin/torque.setup $tmpsetup
        sed -i $tmpsetup -e 's/pbs_server -t create/pbs_server -f -t create/'

        pbs_mkdirs -v aux
        pbs_mkdirs -v server
        hostname > /var/spool/torque/server_name
        cp -prv ${torque}/var/spool/torque/* /var/spool/torque/
        $tmpsetup root

        sleep 1
        rm -f $tmpsetup
        kill $(pgrep pbs_server) 2>/dev/null
        kill $(pgrep trqauthd) 2>/dev/null
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      unitConfig = {
        ConditionPathExists = "!/var/spool/torque";
      };
    };

    systemd.services.trqauthd = {
      path = [ torque ];

      requires = [ "torque-server-init.service" ];
      after = [ "torque-server-init.service" ];

      serviceConfig = {
        Type = "forking";
        ExecStart = "${torque}/bin/trqauthd";
      };
    };

    systemd.services.torque-server = {
      path = [ torque ];

      wantedBy = [ "multi-user.target" ];
      wants = [
        "torque-scheduler.service"
        "trqauthd.service"
      ];
      before = [ "trqauthd.service" ];
      requires = [ "torque-server-init.service" ];
      after = [
        "torque-server-init.service"
        "network.target"
      ];

      serviceConfig = {
        Type = "forking";
        ExecStart = "${torque}/bin/pbs_server";
        ExecStop = "${torque}/bin/qterm";
        PIDFile = "/var/spool/torque/server_priv/server.lock";
      };
    };

    systemd.services.torque-scheduler = {
      path = [ torque ];

      requires = [ "torque-server-init.service" ];
      after = [ "torque-server-init.service" ];

      serviceConfig = {
        Type = "forking";
        ExecStart = "${torque}/bin/pbs_sched";
        PIDFile = "/var/spool/torque/sched_priv/sched.lock";
      };
    };

  };
}
