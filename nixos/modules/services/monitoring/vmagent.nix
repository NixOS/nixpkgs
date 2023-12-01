{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.vmagent;
  settingsFormat = pkgs.formats.json { };
in {
  options.services.vmagent = {
    enable = mkEnableOption (lib.mdDoc "vmagent");

    user = mkOption {
      default = "vmagent";
      type = types.str;
      description = lib.mdDoc ''
        User account under which vmagent runs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "vmagent";
      description = lib.mdDoc ''
        Group under which vmagent runs.
      '';
    };

    package = mkPackageOption pkgs "vmagent" { };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/vmagent";
      description = lib.mdDoc ''
        The directory where vmagent stores its data files.
      '';
    };

    remoteWriteUrl = mkOption {
      default = "http://localhost:8428/api/v1/write";
      type = types.str;
      description = lib.mdDoc ''
        The storage endpoint such as VictoriaMetrics
      '';
    };

    prometheusConfig = mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      description = lib.mdDoc ''
        Config for prometheus style metrics
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to open the firewall for the default ports.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        Extra args to pass to `vmagent`. See the docs:
        <https://docs.victoriametrics.com/vmagent.html#advanced-usage>
        or {command}`vmagent -help` for more information.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.groups = mkIf (cfg.group == "vmagent") { vmagent = { }; };

    users.users = mkIf (cfg.user == "vmagent") {
      vmagent = {
        group = cfg.group;
        description = "vmagent daemon user";
        home = cfg.dataDir;
        isSystemUser = true;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 8429 ];

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
        ExecStart = "${cfg.package}/bin/vmagent -remoteWrite.url=${cfg.remoteWriteUrl} -promscrape.config=${prometheusConfig} ${escapeShellArgs cfg.extraArgs}";
      };
    };

    systemd.tmpfiles.rules =
      [ "d '${cfg.dataDir}' 0755 ${cfg.user} ${cfg.group} -" ];
  };
}
