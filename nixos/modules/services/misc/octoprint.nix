{
  config,
  lib,
  pkgs,
  ...
}:
let

  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkOption
    mkRenamedOptionModule
    optional
    types
    versionOlder
    ;

  cfg = config.services.octoprint;

  formatType = pkgs.formats.json { };

  configFile = formatType.generate "octoprint-config.yaml" cfg.settings;

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

      plugins = mkOption {
        type = types.functionTo (types.listOf types.package);
        default = _plugins: [ ];
        defaultText = literalExpression "plugins: []";
        example = literalExpression "plugins: with plugins; [ themeify stlviewer ]";
        description = "Additional plugins to be used. Available plugins are passed through the plugins input.";
      };

      settings = mkOption {
        default = { };
        description = ''
          The octoprint settings, for definitions see the upstream [documentation](https://docs.octoprint.org).
          Will override any existing settings.
        '';
        type = types.submodule {
          freeformType = formatType.type;
          config = {
            plugins.curalegacy.cura_engine = mkDefault "${pkgs.curaengine_stable}/bin/CuraEngine";
            server.host = cfg.host;
            server.port = cfg.port;
            webcam.ffmpeg = mkDefault "${pkgs.ffmpeg.bin}/bin/ffmpeg";
          };
        };
      };
      enableRaspberryPi = mkEnableOption "RaspberryPi specific hardware access rules" // {
        default = versionOlder config.system.stateVersion "25.05";
      };

    };

  };

  ##### implementation
  imports = [
    (mkRenamedOptionModule
      [
        "services"
        "octoprint"
        "extraConfig"
      ]
      [
        "services"
        "octoprint"
        "settings"
      ]
    )
  ];

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

    systemd.tmpfiles.rules =
      [ "d '${cfg.stateDir}' - ${cfg.user} ${cfg.group} - -" ]
      ++ optional cfg.enableRaspberryPi
        # this will allow octoprint access to raspberry specific hardware to check for throttling
        # read-only will not work: "VCHI initialization failed" error
        # FIXME: this should probably be a udev rule
        "a /dev/vchiq - - - - u:octoprint:rw";

    systemd.services.octoprint = {
      description = "OctoPrint, web interface for 3D printers";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pluginsEnv ];

      preStart = ''
        if [ -e "${cfg.stateDir}/config.yaml" ]; then
          ${pkgs.yaml-merge}/bin/yaml-merge "${cfg.stateDir}/config.yaml" "${configFile}" > "${cfg.stateDir}/config.yaml.tmp"
          mv "${cfg.stateDir}/config.yaml.tmp" "${cfg.stateDir}/config.yaml"
        else
          cp "${configFile}" "${cfg.stateDir}/config.yaml"
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

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
        ];
        ReadWritePaths = [ cfg.stateDir ];
        UMask = "0077";

      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
  meta.maintainers = with lib.maintainers; [ patrickdag ];
}
