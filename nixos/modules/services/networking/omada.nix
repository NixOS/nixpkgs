{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.omada;
in

{
  options = {
    services.omada = {
      enable = lib.mkEnableOption "Enable the Omada Software Controller service.";

      package = lib.mkPackageOption pkgs "omada-software-controller" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "omada";
        description = ''
          User under which the Omada Software Controller service runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "omada";
        description = ''
          Group under which the Omada Software Controller service runs.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/omada";
        description = ''
          The path where the Omada Software Controller stores all data. This path must
          be in sync with the omada-software-controller package (where it is hardcoded
          during the build in accordance with its own `dataDir` argument).
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open the required firewall ports for Omada Software Controller.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };

    users.users.${cfg.user} = {
      description = "Omada Software Controller user";
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };

    systemd.services.omada = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Omada Software Controller";

      preStart = ''
        mkdir -p ${cfg.dataDir}/{data,logs,properties,work}
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/omada start";
        ExecStop = "${cfg.package}/bin/omada stop";
        Type = "forking";
        TimeoutSec = 300;
        RuntimeDirectory = "omada";
        RuntimeDirectoryMode = "0755";
        PIDFile = "/run/omada/omada.pid";
        WorkingDirectory = cfg.dataDir;
        StateDirectory = baseNameOf cfg.dataDir;
        User = cfg.user;
        Group = cfg.group;
        Environment = [
          "OMADA_USER=${cfg.user}"
        ];
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedUDPPorts = [
        19810 # discovery port
        29810 # discovery port
      ];
      allowedTCPPorts = [
        8043 # web port
        8088 # web port
        29811 # management port
        29812 # adoption port
        29813 # upgrade port
        29814 # management port
        29815 # transfer port
        29816 # rtty port
      ];
    };
  };
}
