{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.autotierfs;
  ini = pkgs.formats.ini { };
  format = lib.types.attrsOf ini.type;
  stateDir = "/var/lib/autotier";

  generateConfigName =
    name: builtins.replaceStrings [ "/" ] [ "-" ] (lib.strings.removePrefix "/" name);
  configFiles = builtins.mapAttrs (
    name: val: ini.generate "${generateConfigName name}.conf" val
  ) cfg.settings;

  getMountDeps =
    settings: builtins.concatStringsSep " " (builtins.catAttrs "Path" (builtins.attrValues settings));

  mountPaths = builtins.attrNames cfg.settings;
in
{
  options.services.autotierfs = {
    enable = lib.mkEnableOption "the autotier passthrough tiering filesystem";
    package = lib.mkPackageOption pkgs "autotier" { };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format;
      };
      default = { };
      description = ''
        The contents of the configuration file for autotier.
        See the [autotier repo](https://github.com/45Drives/autotier#configuration) for supported values.
      '';
      example = lib.literalExpression ''
        {
          "/mnt/autotier" = {
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
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings != { };
        message = "`services.autotierfs.settings` must be configured.";
      }
    ];

    system.fsPackages = [ cfg.package ];

    # Not necessary for module to work but makes it easier to pass config into cli
    environment.etc = lib.attrsets.mapAttrs' (
      name: value:
      lib.attrsets.nameValuePair "autotier/${(generateConfigName name)}.conf" { source = value; }
    ) configFiles;

    systemd.tmpfiles.rules = (map (path: "d ${path} 0770 - autotier - -") mountPaths) ++ [
      "d ${stateDir} 0774 - autotier - -"
    ];

    users.groups.autotier = { };

    systemd.services = lib.attrsets.mapAttrs' (
      path: values:
      lib.attrsets.nameValuePair (generateConfigName path) {
        description = "Mount autotierfs virtual path ${path}";
        unitConfig.RequiresMountsFor = getMountDeps values;
        wantedBy = [ "local-fs.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${lib.getExe' cfg.package "autotierfs"} -c /etc/autotier/${generateConfigName path}.conf ${path} -o allow_other,default_permissions";
          ExecStop = "umount ${path}";
        };
      }
    ) cfg.settings;
  };
}
