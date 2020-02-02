{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.octoprint;

  baseConfig = {
    plugins.curalegacy.cura_engine = "${pkgs.curaengine_stable}/bin/CuraEngine";
    server.host = cfg.host;
    server.port = cfg.port;
    webcam.ffmpeg = "${pkgs.ffmpeg.bin}/bin/ffmpeg";
  };

  fullConfig = recursiveUpdate cfg.extraConfig baseConfig;

  cfgUpdate = pkgs.writeText "octoprint-config.yaml" (builtins.toJSON fullConfig);

  pluginsEnv = pkgs.python.buildEnv.override {
    extraLibs = cfg.plugins pkgs.octoprint-plugins;
  };

in
{
  ##### interface

  options = {

    services.octoprint = {

      enable = mkEnableOption "OctoPrint, web interface for 3D printers";

      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          Host to bind OctoPrint to.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 5000;
        description = ''
          Port to bind OctoPrint to.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "octoprint";
        description = "User for the daemon.";
      };

      group = mkOption {
        type = types.str;
        default = "octoprint";
        description = "Group for the daemon.";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/octoprint";
        description = "State directory of the daemon.";
      };

      plugins = mkOption {
        default = plugins: [];
        defaultText = "plugins: []";
        example = literalExample "plugins: [ m3d-fio ]";
        description = "Additional plugins.";
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        description = "Extra options which are added to OctoPrint's YAML configuration file.";
      };

    };

  };

  ##### implementation

  config = mkIf cfg.enable {

    users.users = optionalAttrs (cfg.user == "octoprint") {
      octoprint = {
        group = cfg.group;
        uid = config.ids.uids.octoprint;
      };
    };

    users.groups = optionalAttrs (cfg.group == "octoprint") {
      octoprint.gid = config.ids.gids.octoprint;
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.octoprint = {
      description = "OctoPrint, web interface for 3D printers";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pluginsEnv ];
      environment.PYTHONPATH = makeSearchPathOutput "lib" pkgs.python.sitePackages [ pluginsEnv ];

      preStart = ''
        if [ -e "${cfg.stateDir}/config.yaml" ]; then
          ${pkgs.yaml-merge}/bin/yaml-merge "${cfg.stateDir}/config.yaml" "${cfgUpdate}" > "${cfg.stateDir}/config.yaml.tmp"
          mv "${cfg.stateDir}/config.yaml.tmp" "${cfg.stateDir}/config.yaml"
        else
          cp "${cfgUpdate}" "${cfg.stateDir}/config.yaml"
          chmod 600 "${cfg.stateDir}/config.yaml"
        fi
      '';

      serviceConfig = {
        ExecStart = "${pkgs.octoprint}/bin/octoprint serve -b ${cfg.stateDir}";
        User = cfg.user;
        Group = cfg.group;
      };
    };

  };

}
