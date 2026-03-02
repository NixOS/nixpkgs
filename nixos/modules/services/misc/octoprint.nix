{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.octoprint;

  baseConfig = lib.recursiveUpdate {
    plugins.curalegacy.cura_engine = "${pkgs.curaengine_stable}/bin/CuraEngine";
    server.port = cfg.port;
    webcam.ffmpeg = "${pkgs.ffmpeg.bin}/bin/ffmpeg";
  } (lib.optionalAttrs (cfg.host != null) { server.host = cfg.host; });

  fullConfig = lib.recursiveUpdate cfg.extraConfig baseConfig;

  cfgUpdate = pkgs.writeText "octoprint-config.yaml" (builtins.toJSON fullConfig);

  pluginsEnv = cfg.package.python.withPackages (ps: [ ps.octoprint ] ++ (cfg.plugins ps));

in
{
  ##### interface

  options = {

    services.octoprint = {

      package = lib.mkPackageOption pkgs "octoprint" { };

      enable = lib.mkEnableOption "OctoPrint, web interface for 3D printers";

      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Host to bind OctoPrint to.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5000;
        description = ''
          Port to bind OctoPrint to.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for OctoPrint.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "octoprint";
        description = "User for the daemon.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "octoprint";
        description = "Group for the daemon.";
      };

      stateDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/octoprint";
        description = "State directory of the daemon.";
      };

      plugins = lib.mkOption {
        type = lib.types.functionTo (lib.types.listOf lib.types.package);
        default = plugins: [ ];
        defaultText = lib.literalExpression "plugins: []";
        example = lib.literalExpression "plugins: with plugins; [ themeify stlviewer ]";
        description = "Additional plugins to be used. Available plugins are passed through the plugins input.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Extra options which are added to OctoPrint's YAML configuration file.";
      };

    };

  };

  ##### implementation

  config = lib.mkIf cfg.enable {

    users.users = lib.optionalAttrs (cfg.user == "octoprint") {
      octoprint = {
        group = cfg.group;
        uid = config.ids.uids.octoprint;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "octoprint") {
      octoprint.gid = config.ids.gids.octoprint;
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' - ${cfg.user} ${cfg.group} - -"
      # this will allow octoprint access to raspberry specific hardware to check for throttling
      # read-only will not work: "VCHI initialization failed" error
      "a /dev/vchiq - - - - u:octoprint:rw"
    ];

    systemd.services.octoprint = {
      description = "OctoPrint, web interface for 3D printers";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pluginsEnv ];

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
        ExecStart = "${pluginsEnv}/bin/octoprint serve -b ${cfg.stateDir}";
        User = cfg.user;
        Group = cfg.group;
        SupplementaryGroups = [
          "dialout"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
