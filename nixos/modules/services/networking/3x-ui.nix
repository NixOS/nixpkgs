{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services._3x-ui;

  inherit (lib)
    getExe
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in
{
  options.services._3x-ui = {
    enable = mkEnableOption "3x-ui";

    port = mkOption {
      description = "Port for control panal, null for self-managed";
      type = types.nullOr types.port;
      default = null;
    };

    openFirewall = mkEnableOption "open firewall ports for 3x-ui";

    dataDir = mkOption {
      description = "Directory for service data";
      type = types.path;
      default = "/var/lib/3x-ui";
    };

    user = mkOption {
      type = types.str;
      default = "_3x-ui";
      description = "User account under which 3x-ui runs";
    };

    group = mkOption {
      type = types.str;
      default = "_3x-ui";
      description = "Group under which 3x-ui runs";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.proxydetox;
      defaultText = "pkgs._3x-ui";
      description = "The 3x-ui derivation to use";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.port != null) || !cfg.openFirewall;
        message = "Port is unknown for firewall opening";
      }
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 _3x-ui _3x-ui -"
      "d ${cfg.dataDir}/bin 0755 _3x-ui _3x-ui -"
      "d ${cfg.dataDir}/logs 0755 _3x-ui _3x-ui -"
    ];

    systemd.services._3x-ui = {
      description = "3x-ui control panel";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        ln -sf ${getExe pkgs.xray} ${cfg.dataDir}/bin/xray-linux-amd64
      ''
      + (
        if cfg.port != null then
          ''
            ${getExe pkgs._3x-ui} setting -port ${toString cfg.port}
          ''
        else
          ""
      );

      environment = {
        XUI_DB_FOLDER = cfg.dataDir;
        XUI_BIN_FOLDER = "${cfg.dataDir}/bin";
        XUI_LOG_FOLDER = "${cfg.dataDir}/logs";
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.user;
        Restart = "on-failure";

        ExecStart = "${getExe pkgs._3x-ui}";

        AmbientCapabilities = [
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_ADMIN"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_ADMIN"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = mkIf (cfg.openFirewall && (cfg.port != null)) [ cfg.port ];

    users.users = mkIf (cfg.user == "_3x-ui") {
      _3x-ui = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "_3x-ui") {
      _3x-ui = { };
    };
  };

  meta.maintainers = with lib.maintainers; [
    maxmosk
  ];
}
