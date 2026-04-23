{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.scanservjs;
  settings = {
    scanimage = lib.getExe' config.hardware.sane.backends-package "scanimage";
    convert = lib.getExe' pkgs.imagemagick "convert";
    tesseract = lib.getExe pkgs.tesseract;
    # it defaults to config/devices.json, but "config" dir doesn't exist by default and scanservjs doesn't create it
    devicesPath = "devices.json";
  }
  // cfg.settings;
  settingsFormat = pkgs.formats.json { };

  leafs =
    attrs:
    builtins.concatLists (
      lib.mapAttrsToList (k: v: if builtins.isAttrs v then leafs v else [ v ]) attrs
    );

  package = pkgs.scanservjs;

  configFile = pkgs.writeText "config.local.js" ''
    /* eslint-disable no-unused-vars */
    module.exports = {
      afterConfig(config) {
        ${builtins.concatStringsSep "" (
          leafs (
            lib.mapAttrsRecursive (path: val: ''
              ${builtins.concatStringsSep "." path} = ${builtins.toJSON val};
            '') { config = settings; }
          )
        )}
        ${cfg.extraConfig}
      },

      afterDevices(devices) {
        ${cfg.extraDevicesConfig}
      },

      async afterScan(fileInfo) {
        ${cfg.runAfterScan}
      },

      actions: [
        ${builtins.concatStringsSep ",\n" cfg.extraActions}
      ],
    };
  '';

in
{
  options.services.scanservjs = {
    enable = lib.mkEnableOption "scanservjs";
    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/scanservjs";
      description = ''
        State directory for scanservjs.
      '';
    };
    settings = lib.mkOption {
      default = { };
      description = ''
        Config to set in config.local.js's `afterConfig`.
      '';
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options.host = lib.mkOption {
          type = lib.types.str;
          description = "The IP to listen on.";
          default = "127.0.0.1";
        };
        options.port = lib.mkOption {
          type = lib.types.port;
          description = "The port to listen on.";
          default = 8080;
        };
      };
    };
    extraConfig = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = ''
        Extra code to add to config.local.js's `afterConfig`.
      '';
    };
    extraDevicesConfig = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = ''
        Extra code to add to config.local.js's `afterDevices`.
      '';
    };
    runAfterScan = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = ''
        Extra code to add to config.local.js's `afterScan`.
      '';
    };
    extraActions = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.lines;
      description = "Actions to add to config.local.js's `actions`.";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.sane.enable = true;
    users.users.scanservjs = {
      group = "scanservjs";
      extraGroups = [
        "scanner"
        "lp"
      ];
      home = cfg.stateDir;
      isSystemUser = true;
      createHome = true;
    };
    users.groups.scanservjs = { };

    systemd.services.scanservjs = {
      description = "scanservjs";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # yes, those paths are configurable, but the config option isn't always used...
      # a lot of the time scanservjs just takes those from PATH
      path = with pkgs; [
        coreutils
        config.hardware.sane.backends-package
        imagemagick
        tesseract
      ];
      environment = {
        NIX_SCANSERVJS_CONFIG_PATH = configFile;
        SANE_CONFIG_DIR = "/etc/sane-config";
        LD_LIBRARY_PATH = "/etc/sane-libs";
      };
      serviceConfig = {
        ExecStart = lib.getExe package;
        Restart = "always";
        User = "scanservjs";
        Group = "scanservjs";
        WorkingDirectory = cfg.stateDir;
      };
    };
  };
}
