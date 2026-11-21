{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.sema;
  nbCfg = config.services.sema-notebook;
in
{
  options = {
    programs.sema = {
      enable = lib.mkEnableOption "sema, a Lisp dialect with first-class LLM primitives";

      package = lib.mkPackageOption pkgs "sema" { };
    };

    services.sema-notebook = {
      enable = lib.mkEnableOption "Sema notebook server";

      package = lib.mkPackageOption pkgs "sema" { };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          Host address to bind the notebook server to.
          Defaults to loopback (127.0.0.1) for security, as the notebook server has no built-in auth layer.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8888;
        description = "Port to listen on.";
      };

      notebookFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to the .sema-nb file to serve (created if absent).";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "sema-notebook";
        description = "User account under which the notebook service runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "sema-notebook";
        description = "Group account under which the notebook service runs.";
      };

      stateDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/sema-notebook";
        description = "Directory for notebook runtime state.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open the notebook server port in the firewall.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];
    })

    (lib.mkIf nbCfg.enable {
      users.users.${nbCfg.user} = {
        isSystemUser = true;
        group = nbCfg.group;
        home = nbCfg.stateDir;
        createHome = true;
        description = "Sema notebook daemon user";
      };

      users.groups.${nbCfg.group} = { };

      networking.firewall = lib.mkIf nbCfg.openFirewall {
        allowedTCPPorts = [ nbCfg.port ];
      };

      systemd.services.sema-notebook = {
        description = "Sema Notebook Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = nbCfg.user;
          Group = nbCfg.group;
          StateDirectory = "sema-notebook";
          WorkingDirectory = nbCfg.stateDir;
          ExecStart = lib.escapeShellArgs (
            [
              (lib.getExe nbCfg.package)
              "notebook"
              "serve"
              "--host"
              nbCfg.host
              "--port"
              (toString nbCfg.port)
            ]
            ++ lib.optional (nbCfg.notebookFile != null) (toString nbCfg.notebookFile)
          );
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [ crimeminister ];
}
