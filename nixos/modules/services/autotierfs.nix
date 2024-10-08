{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.autotierfs;
  format = pkgs.formats.ini { };
  configFile = format.generate "autotier.conf" cfg.settings;
  docUrl = "https://github.com/45Drives/autotier#configuration";
  configPath = "/etc/autotier.conf";

  getMountDeps = settings: builtins.catAttrs "Path" (builtins.attrValues settings);
in
{
  options.services.autotierfs = {
    enable = lib.mkEnableOption "the autotier passthrough tiering filesystem";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.autotier;
      defaultText = lib.options.literalExpression "pkgs.autotier";
      description = "Configured package for the filesystem and its cli.";
    };
    mountPath = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/autotier";
      example = "/mnt/autotier";
      description = ''
        Mount location of the autotier virtual device.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.nullOr format.type;
      default = null;
      description = ''
        The contents of the configuration file for autotier.
      '';
      example = {
        Global = {
          "Log Level" = 1;
          "Tier Period" = 1000;
          "Copy Buffer Size" = "1 MiB";
        };
        "Tier 1" = {
          Path = "/mnt/tier1";
          Quota = "30GiB";
        };
        "Tier 2" = {
          Path = "/mnt/tier2";
          Quota = "200GiB";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> cfg.settings != null;
        message = "Autotier needs a config file to know how to tier your paths.";
      }
    ];

    system.fsPackages = [ cfg.package ];

    systemd.tmpfiles.rules = [
      "L+ ${configPath}  - - - - ${configFile}"
      "d ${cfg.mountPath} - - - - -"
    ];

    fileSystems.${cfg.mountPath} = {
      device = "${pkgs.autotier}/bin/autotierfs";
      fsType = "fuse";
      depends = getMountDeps cfg.settings;
      options = [
        "allow_other"
        "default_permissions"
      ];
    };
  };
}
