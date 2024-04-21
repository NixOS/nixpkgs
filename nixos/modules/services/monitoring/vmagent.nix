{ config, pkgs, lib, ... }:

let
  cfg = config.services.vmagent;
  settingsFormat = pkgs.formats.json { };
in {
  options.services.vmagent = {
    enable = lib.mkEnableOption "vmagent";

    user = lib.mkOption {
      default = "vmagent";
      type = lib.types.str;
      description = ''
        User account under which vmagent runs.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "vmagent";
      description = ''
        Group under which vmagent runs.
      '';
    };

    package = lib.mkPackageOption pkgs "vmagent" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/vmagent";
      description = ''
        The directory where vmagent stores its data files.
      '';
    };

    remoteWriteUrl = lib.mkOption {
      default = "http://localhost:8428/api/v1/write";
      type = lib.types.str;
      description = ''
        The storage endpoint such as VictoriaMetrics
      '';
    };

    prometheusConfig = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      description = ''
        Config for prometheus style metrics
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the default ports.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        Extra args to pass to `vmagent`. See the docs:
        <https://docs.victoriametrics.com/vmagent.html#advanced-usage>
        or {command}`vmagent -help` for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups = lib.mkIf (cfg.group == "vmagent") { vmagent = { }; };

    users.users = lib.mkIf (cfg.user == "vmagent") {
      vmagent = {
        group = cfg.group;
        description = "vmagent daemon user";
        home = cfg.dataDir;
        isSystemUser = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 8429 ];

    systemd.services.vmagent = let
      prometheusConfig = settingsFormat.generate "prometheusConfig.yaml" cfg.prometheusConfig;
    in {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "vmagent system service";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        Restart = "on-failure";
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${cfg.package}/bin/vmagent -remoteWrite.url=${cfg.remoteWriteUrl} -promscrape.config=${prometheusConfig} ${lib.escapeShellArgs cfg.extraArgs}";
      };
    };

    systemd.tmpfiles.rules =
      [ "d '${cfg.dataDir}' 0755 ${cfg.user} ${cfg.group} -" ];
  };
}
