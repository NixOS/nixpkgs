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

      openFirewallDevicePorts = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the firewall ports required for Omada devices to communicate
          with the Omada Software Controller (discovery, adoption, management, etc.).
        '';
      };

      openFirewallWebPorts = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the firewall ports of the web interface (8043, 8088).
        '';
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

    systemd.tmpfiles.settings."10-omada" =
      lib.genAttrs
        (map (dir: "${cfg.dataDir}/${dir}") [
          "data"
          "logs"
          "properties"
          "work"
        ])
        (_: {
          d = {
            user = cfg.user;
            group = cfg.group;
          };
        });

    systemd.services.omada = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Omada Software Controller";

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} start";
        ExecStop = "${lib.getExe cfg.package} stop";
        # The control script asks for confirmation (y/n) before starting when
        # it detects that MongoDB was upgraded across major versions. Answer it,
        # otherwise its read loop would spin forever on an EOF stdin.
        StandardInput = "data";
        StandardInputText = "y";
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

    networking.firewall = {
      allowedUDPPorts = lib.optionals cfg.openFirewallDevicePorts [
        19810 # discovery port
        29810 # discovery port
      ];
      allowedTCPPorts =
        lib.optionals cfg.openFirewallDevicePorts [
          29811 # management port
          29812 # adoption port
          29813 # upgrade port
          29814 # management port
          29815 # transfer port
          29816 # rtty port
          29817 # device management port
        ]
        ++ lib.optionals cfg.openFirewallWebPorts [
          8043 # web port (HTTPS)
          8088 # web port (HTTP)
        ];
    };
  };
}
