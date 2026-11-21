{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.pelican-wings;
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    mkDefault
    recursiveUpdate
    maintainers
    getExe
    optionalAttrs
    ;

  isDocker = cfg.containerBackend == "docker";
in
{
  options.services.pelican-wings = {
    enable = mkEnableOption "Pelican Wings daemon";

    package = mkPackageOption pkgs "pelican-wings" { };

    openFirewall = mkEnableOption "firewall rules for Wings. Will open both the SFTP port 2022 and the apiPort. Disable if you're using a reverse proxy and open 2022 manually";

    apiPort = mkOption {
      type = types.port;
      default = 8080;
      description = "Port Wings listens on.";
    };

    domain = mkOption {
      type = types.str;
      description = "the domain to run Wings on. Must be reachable from the panel and from all clients accessing the panel";
    };

    containerBackend = mkOption {
      type = types.enum [
        "docker"
        "podman"
      ];
      default = "docker";
      description = ''
        Select the container backend you want to use.

        If you using `"podman"` Keep the OOM killer enabled on every server.
        Podman uses cgroup v2, which can't disable it, so a server with the OOM killer disabled fails to install or start with cannot disable OOM killer with cgroupv2.
        More information [here](https://pelican.dev/docs/wings/optional-config#running-on-podman).
      '';
    };

    configuration = mkOption {
      type = types.attrs;
      default = { };
      description = "Base Wings configuration written to the Nix store at eval time. Merged with secretConfigurationFile at runtime, with secrets taking precedence.";
    };

    secretConfigurationFile = mkOption {
      type = types.path;
      description = "Path to a YAML file containing secret configuration values. Merged on top of configuration at runtime.";
    };

  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker.enable = mkIf isDocker (mkDefault true);

      podman = mkIf (!isDocker) {
        enable = mkDefault true;
        dockerSocket.enable = true;
      };
    };

    systemd = {
      services.pelican-wings =
        let
          autoConfig = {
            system.sftp.bind_port = 2022;
            api.port = cfg.apiPort;
          }
          // optionalAttrs (!isDocker) {
            # Required according to https://pelican.dev/docs/wings/optional-config#running-on-podman
            system.tmp_directory = "/var/lib/pelican/tmp";
            docker.log_config.type = "k8s-file";
          };
          storeConfig = (pkgs.formats.yaml { }).generate "wings-config.yml" (
            recursiveUpdate autoConfig cfg.configuration
          );
          containerService = if isDocker then "docker.service" else "podman.socket";
        in
        {
          description = "Pelican Wings Daemon";
          after = [ containerService ];
          requires = [ containerService ];
          wantedBy = [ "multi-user.target" ];

          path = with pkgs; [
            shadow
            yq-go
          ];

          serviceConfig = {
            User = "root";
            LimitNOFILE = 4096;
            ExecStartPre = pkgs.writeShellScript "wings-pre" ''
              ${lib.getExe pkgs.yq-go} eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
              ${storeConfig} ${cfg.secretConfigurationFile} > /etc/pelican/config.yml
            '';
            ExecStart = "${getExe cfg.package} --config /etc/pelican/config.yml";
            Restart = "on-failure";
            RestartSec = "5s";
          };

          unitConfig = {
            StartLimitIntervalSec = 180;
            StartLimitBurst = 30;
          };
        };

      tmpfiles.settings."10-pelican-wings" = {
        "/etc/pelican".d.mode = "0700";
        "/var/lib/pelican".d = { };
        "/var/log/pelican/install".d = { };
        "/tmp/pelican".d = { };
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        2022
        cfg.apiPort
      ];
    };
  };

  meta = {
    maintainers = with maintainers; [
      oskardotglobal
      nullcube
      Svenum
      keenanweaver
    ];
    doc = ./pelican-wings.md;
  };
}
