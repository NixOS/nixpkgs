{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nylon-wg;
  # Is there a better way? lib.isPath does not work
  keyIsPath = builtins.match "^/.+" cfg.node.key != null;
  nodeBaseCfg = pkgs.writeText "node_base.yml" (
    ''
      id: "${cfg.node.id}"
      port: ${builtins.toString cfg.node.port}
      interfacename: "${cfg.node.interface}"
      logpath: "${builtins.toString cfg.node.logPath}"
      nonetconfigure: ${lib.boolToString cfg.node.noNetConfigure}
      usesystemrouting: ${lib.boolToString cfg.node.useSystemRouting}
      disablerouting: ${lib.boolToString cfg.node.disableRouting}
    ''
    + lib.optionalString (!keyIsPath) ''
      key: ${cfg.node.key}
    ''
  );
in
{
  options = {
    services.nylon-wg = {
      enable = lib.mkEnableOption "Nylon - Resilient Overlay Network built from WireGuard";

      centralConfig = lib.mkOption {
        type = with lib.types; path;
        description = "Path to nylon central config.";
      };

      node = {
        key = lib.mkOption {
          type = with lib.types; either path str;
          description = ''
            Node key as string or path to node key
            A path is preferred as else the key will be commited to the nix-store.
          '';
        };
        port = lib.mkOption {
          type = with lib.types; int;
          default = 57175;
          description = "Port for nylon to listen on.";
        };
        interface = lib.mkOption {
          type = with lib.types; str;
          default = "nylon";
          description = "Interface for nylon to listen on.";
        };
        id = lib.mkOption {
          type = with lib.types; str;
          description = "Nylon node id";
        };
        logPath = lib.mkOption {
          type = with lib.types; nullOr path;
          default = null;
          description = "Log to this file";
        };
        noNetConfigure = lib.mkOption {
          type = with lib.types; bool;
          default = false;
          description = "Do not configure the system network settings.";
        };
        useSystemRouting = lib.mkOption {
          type = with lib.types; bool;
          default = false;
          description = "Use the system route table to forward packets";
        };
        disableRouting = lib.mkOption {
          type = with lib.types; bool;
          default = false;
          description = "Do not route traffic through this node";
        };
      };
      openFirewall = lib.mkOption {
        type = with lib.types; bool;
        default = true;
        description = "Configure firewall to trust nylon port and interface";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedUDPPorts = [ cfg.node.port ];
      trustedInterfaces = [ cfg.node.interface ];
    };

    boot.kernel.sysctl = lib.mkIf cfg.node.useSystemRouting {
      "net.ipv4.conf.all.forwarding" = lib.mkOverride 97 true;
      "net.ipv6.conf.all.forwarding" = lib.mkOverride 97 true;
    };

    systemd.services.nylon-wg = {
      description = "Nylon - Resilient Overlay Network built from WireGuard";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig =
        let
          sh = lib.getExe' pkgs.bash "sh";
          cat = lib.getExe' pkgs.coreutils "cat";
          echo = lib.getExe' pkgs.coreutils "echo";
          rm = lib.getExe' pkgs.coreutils "rm";
          nylon-wg = lib.getExe pkgs.nylon-wg;
          keyLine = ''${echo} -en "\nkey: " && ${cat} ${cfg.node.key}'';
        in
        {
          RuntimeDirectory = "nylon-wg";
          WorkingDirectory = "%t/nylon-wg";
          RuntimeDirectoryMode = "0640";
          UMask = "0007";
          ExecStartPre = "${sh} -c '{ ${cat} ${nodeBaseCfg} ${
            lib.optionalString keyIsPath ("&& " + keyLine)
          } ;} > node.yaml'";
          ExecStart = "${nylon-wg} run -c ${cfg.centralConfig} -n node.yaml";
          ExecStop = "-${rm} -f node.yaml";
          Restart = "always";
          RestartSec = "10s";
        };
    };
  };

  meta.maintainers = with lib.maintainers; [ smephite ];
}
