{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.k3s;
in
{
  # interface
  options.services.k3s = {
    enable = mkEnableOption "k3s";

    role = mkOption {
      description = ''
        Whether k3s should run as a server or agent.
        Note that the server, by default, also runs as an agent.
      '';
      default = "server";
      type = types.enum [ "server" "agent" ];
    };

    serverAddr = mkOption {
      type = types.str;
      description = "The k3s server to connect to. This option only makes sense for an agent.";
      example = "https://10.0.0.10:6443";
      default = "";
    };
    token = mkOption {
      type = types.str;
      description = "The k3s token to use when connecting to the server. This option only makes sense for an agent.";
    };

    docker = mkOption {
      type = types.bool;
      default = false;
      description = "Use docker to run containers rather than the built-in containerd.";
    };

    extraFlags = mkOption {
      description = "Extra flags to pass to the k3s command.";
      default = "";
      example = "--no-deplooy traefik --cluster-cidr 10.24.0.0/16";
    };

    disableAgent = mkOption {
      type = types.bool;
      default = false;
      description = "Only run the server. This option only makes sense for a server.";
    };
  };

  # implementation
  config = mkMerge [
    (
      mkIf (cfg.role == "server") {
        services.k3s.serverAddr = "";
        services.k3s.token = "";
      }
    )
    (
      mkIf cfg.docker {
        virtualisation.docker = {
          enable = mkDefault true;
        };
      }
    )
    (
      mkIf cfg.enable {
        systemd.services.k3s = let
          flags = concatStrings (
            intersperse " " (
              remove "" [
                (if cfg.docker then "--docker" else "")
                (if (cfg.serverAddr != "") then "--server ${cfg.serverAddr}" else "")
                (if (cfg.token != "") then "--token ${cfg.token}" else "")
                (if cfg.disableAgent then "--disable-agent" else "")
                cfg.extraFlags
              ]
            )
          );
        in
          {
            description = "k3s service";
            after = if cfg.docker then [ "docker.service" ] else [];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              # Taken from https://github.com/rancher/k3s/blob/v1.17.4+k3s1/contrib/ansible/roles/k3s/node/templates/k3s.service.j2
              Type = "notify";
              KillMode = "process";
              Delegate = "yes";
              LimitNOFILE = "infinity";
              LimitNPROC = "infinity";
              LimitCORE = "infinity";
              TasksMax = "infinity";
              Restart = "always";
              RestartSec = "5s";
              ExecStart = "${pkgs.k3s}/bin/k3s ${cfg.role} ${flags}";
            };
          };

        environment.systemPackages = [ pkgs.k3s ] ++ (if cfg.docker then [ pkgs.docker ] else []);
      }
    )
  ];
}
