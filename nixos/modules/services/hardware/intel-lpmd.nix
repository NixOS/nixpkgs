{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.intel-lpmd;

  shippedConfigFiles = [
    "intel_lpmd_config.xml"
    "intel_lpmd_config_F6_M170.xml"
    "intel_lpmd_config_F6_M181.xml"
    "intel_lpmd_config_F6_M189.xml"
    "intel_lpmd_config_F6_M204.xml"
    "intel_lpmd_config_F6_M213.xml"
    "process_cpuset.xml"
  ];

  packageConfigDir = "${cfg.package}/share/intel-lpmd";

  # Set each top-level element, appending it where a file lacks it.
  overriddenConfigDir =
    pkgs.runCommand "intel-lpmd-configs" { nativeBuildInputs = [ pkgs.xmlstarlet ]; }
      ''
        cp -r ${packageConfigDir} $out
        chmod -R u+w $out
        for file in $out/intel_lpmd_config*.xml; do
          xmlstarlet ed --inplace --pf ${
            lib.escapeShellArgs (
              lib.concatLists (
                lib.mapAttrsToList (name: val: [
                  "-s"
                  "/Configuration[not(${name})]"
                  "-t"
                  "elem"
                  "-n"
                  name
                  "-v"
                  (toString val)
                  "-u"
                  "/Configuration/${name}"
                  "-v"
                  (toString val)
                ]) cfg.configOverrides
              )
            )
          } "$file"
        done
      '';

  configDir = if cfg.configOverrides == { } then packageConfigDir else overriddenConfigDir;
in
{
  options = {
    services.intel-lpmd = {
      enable = lib.mkEnableOption "Intel's low power mode daemon";
      package = lib.mkPackageOption pkgs "intel-lpmd" { };

      configOverrides = lib.mkOption {
        type = with lib.types; attrsOf (either int str);
        default = { };
        example = {
          BalancedDef = 0;
          PowersaverDef = 0;
        };
        description = ''
          Top-level elements to set in every shipped platform configuration file,
          `intel_lpmd_config*.xml`. Elements missing from a file are added to it.
          The daemon refuses to start if an element is unknown or has an invalid value.

          See {manpage}`intel_lpmd_config.xml(5)` and the
          [shipped configuration files](https://github.com/intel/intel-lpmd/tree/main/data)
          for available elements.
          Use {option}`services.intel-lpmd.configFile` to change nested elements such as `States`.
        '';
      };

      configFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        example = lib.literalExpression "./intel_lpmd_config.xml";
        description = ''
          XML configuration file passed to the daemon with `--config`.
          It takes precedence over the platform configuration files in `/etc/intel_lpmd`.
          Process classification rules still load from `/etc/intel_lpmd`.

          The module links the shipped configuration files into `/etc/intel_lpmd`.
          Use {option}`environment.etc` to replace or disable individual files.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.configFile == null || cfg.configOverrides == { };
        message = "services.intel-lpmd.configOverrides has no effect when services.intel-lpmd.configFile is set.";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    environment.etc = lib.genAttrs' shippedConfigFiles (name: {
      name = "intel_lpmd/${name}";
      value.source = "${configDir}/${name}";
    });

    services.dbus.packages = [ cfg.package ];

    systemd = {
      packages = [ cfg.package ];
      services.intel_lpmd = {
        wantedBy = [ "multi-user.target" ];
        aliases = [ "org.freedesktop.intel_lpmd.service" ];
        serviceConfig.ExecStart = [
          ""
          (lib.escapeShellArgs (
            [
              (lib.getExe' cfg.package "intel_lpmd")
              "--systemd"
              "--dbus-enable"
            ]
            ++ lib.optionals (cfg.configFile != null) [
              "--config"
              "${cfg.configFile}"
            ]
          ))
        ];
      };
    };
  };
}
