{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.intel-lpmd;
  packageDefaultConfigDir = "share/intel-lpmd";

  defaultConfigFiles = [
    "intel_lpmd_config.xml"
    "intel_lpmd_config_F6_M170.xml"
    "intel_lpmd_config_F6_M181.xml"
    "intel_lpmd_config_F6_M189.xml"
    "intel_lpmd_config_F6_M204.xml"
    "intel_lpmd_config_F6_M213.xml"
    "process_cpuset.xml"
  ];

  managedConfigFiles = lib.filterAttrs (_: path: path != null) cfg.configFiles;

  mkProfileDef =
    profileName:
    lib.mkOption {
      type = lib.types.enum [
        (-1)
        0
        1
        2
      ];
      default = -1;
      description = ''
        Default behavior when the ${profileName} power profile is active.
        Use -1 to disable low power mode, 0 for automatic mode, 1 to force
        low power mode, or 2 for process classification only.
        Process classification requires `UseProcessCPUSet` in the XML configuration.
      '';
    };
in
{
  options = {
    services.intel-lpmd = {
      enable = lib.mkEnableOption "Intel's low power mode daemon";
      package = lib.mkPackageOption pkgs "intel-lpmd" {
        extraDescription = ''
          The package is expected to provide a `patchedConfigs` passthru for the default value of
          {option}`services.intel-lpmd.overriddenConfigs`.
        '';
      };

      overrideDefaults = lib.mkOption {
        type = lib.types.submodule {
          options = {
            PerformanceDef = mkProfileDef "Performance";
            BalancedDef = mkProfileDef "Balanced";
            PowersaverDef = mkProfileDef "Power Saver";
          };
        };
        default = { };
        description = ''
          Override the upstream default profile behavior values in shipped XML configuration files.
        '';
      };

      overriddenConfigs = lib.mkOption {
        type = lib.types.package;
        internal = true;
        readOnly = true;
        default = cfg.package.patchedConfigs cfg.overrideDefaults;
        defaultText = lib.literalExpression ''
          config.services.intel-lpmd.package.patchedConfigs config.services.intel-lpmd.overrideDefaults
        '';
      };

      configFiles = lib.mkOption {
        type = lib.types.attrsOf (lib.types.nullOr lib.types.path);
        default = lib.genAttrs defaultConfigFiles (
          name: "${cfg.overriddenConfigs}/${packageDefaultConfigDir}/${name}"
        );
        defaultText = lib.literalExpression ''
          patched XML files from `''${config.services.intel-lpmd.overriddenConfigs}/${packageDefaultConfigDir}`
        '';
        description = ''
          XML configuration files to manage under `/etc/intel_lpmd`.

          By default, the module installs the configuration files created by
          {option}`services.intel-lpmd.overriddenConfigs`.
          Override individual entries to use a custom config file instead.

          Set an entry to `null` to stop managing that filename in `/etc/intel_lpmd`,
          which allows it to be managed mutably.

          `process_cpuset.xml` supplies the default process classification rules.
          `process_cpuset_user.xml` is not managed by default, so
          `intel_lpmd_control ADD-PROCESS` can create and update it.
          You can add it here to manage process overrides declaratively instead.

          Upstream loads the most specific matching file first:
          `intel_lpmd_config_F<family>_M<model>_T<tdp>.xml`, then
          `intel_lpmd_config_F<family>_M<model>.xml`, then `intel_lpmd_config.xml`.
        '';
        example = lib.literalExpression ''
          {
            "intel_lpmd_config.xml" = ./intel_lpmd_config.xml;
            "intel_lpmd_config_F6_M170.xml" = null;
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc = lib.mapAttrs' (name: path: {
      name = "intel_lpmd/${name}";
      value.source = path;
    }) managedConfigFiles;

    services.dbus.packages = [ cfg.package ];

    systemd = {
      packages = [ cfg.package ];
      services.intel_lpmd.wantedBy = [ "multi-user.target" ];
    };
  };
}
