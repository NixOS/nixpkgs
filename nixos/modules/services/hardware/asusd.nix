{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.asusd;
  configFiles = {
    "anime.ron" = cfg.animeConfig;
    "asusd.ron" = cfg.asusdConfig;
    "profile.ron" = cfg.profileConfig;
    "fan_curves.ron" = cfg.fanCurvesConfig;
    "asusd_user_ledmodes.ron" = cfg.userLedModesConfig;
  }
  // lib.mapAttrs' (
    productId: value: lib.nameValuePair "aura_${productId}.ron" value
  ) cfg.auraConfigs;
  managedConfigFiles = lib.filterAttrs (_: value: value != null) configFiles;
  configPath = name: "asusd/${name}";
  managedConfigDescription = ''
    By default, the declared content is restored before each asusd start. Set
    {option}`services.asusd.restoreConfigs` to `false` to preserve runtime changes.
  '';
in
{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "services"
        "asusd"
        "auraConfig"
      ]
      ''
        This option has been replaced by `services.asusd.auraConfigs' because asusd
        supports multiple aura devices since version 6.0.0.
      ''
    )
    (lib.mkRemovedOptionModule [
      "services"
      "asusd"
      "enableUserService"
    ] "The asusd user service is no longer required.")
  ];

  options = {
    services.asusd =
      with lib.types;
      let
        configType = submodule (
          { text, source, ... }:
          {
            options = {
              text = lib.mkOption {
                default = null;
                type = nullOr lines;
                description = "Text of the file.";
              };

              source = lib.mkOption {
                default = null;
                type = nullOr path;
                description = "Path of the source file.";
              };
            };
          }
        );
      in
      {
        enable = lib.mkEnableOption "the asusd service for ASUS ROG laptops";

        package = lib.mkPackageOption pkgs "asusctl" { };

        restoreConfigs = lib.mkOption {
          type = bool;
          default = true;
          description = ''
            Whether to restore declared configuration files before each asusd start.
            Disable this to preserve runtime changes across service restarts.
          '';
        };

        animeConfig = lib.mkOption {
          type = nullOr configType;
          default = null;
          description = ''
            The content of /etc/asusd/anime.ron.
            See <https://asus-linux.org/manual/asusctl-manual/#anime-control>.
            ${managedConfigDescription}
          '';
        };

        asusdConfig = lib.mkOption {
          type = nullOr configType;
          default = null;
          description = ''
            The content of /etc/asusd/asusd.ron.
            See <https://asus-linux.org/manual/asusctl-manual/>.
            ${managedConfigDescription}
          '';
        };

        auraConfigs = lib.mkOption {
          type = attrsOf configType;
          default = { };
          description = ''
            The content of /etc/asusd/aura_<name>.ron.
            See <https://asus-linux.org/manual/asusctl-manual/#led-keyboard-control>.
            ${managedConfigDescription}
          '';
        };

        profileConfig = lib.mkOption {
          type = nullOr configType;
          default = null;
          description = ''
            The content of /etc/asusd/profile.ron.
            See <https://asus-linux.org/manual/asusctl-manual/#profiles>.
            ${managedConfigDescription}
          '';
        };

        fanCurvesConfig = lib.mkOption {
          type = nullOr configType;
          default = null;
          description = ''
            The content of /etc/asusd/fan_curves.ron.
            See <https://asus-linux.org/manual/asusctl-manual/#fan-curves>.
            ${managedConfigDescription}
          '';
        };

        userLedModesConfig = lib.mkOption {
          type = nullOr configType;
          default = null;
          description = ''
            The content of /etc/asusd/asusd-user-ledmodes.ron.
            See <https://asus-linux.org/manual/asusctl-manual/#led-keyboard-control>.
            ${managedConfigDescription}
          '';
        };
      };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    assertions = lib.mapAttrsToList (name: file: {
      assertion = file.mode != "symlink";
      message = ''
        `/etc/${name}` must be writable by asusd. Use the matching
        `services.asusd.*Config` option or set `environment.etc."${name}".mode` to a regular file mode.
      '';
    }) (lib.filterAttrs (name: _: lib.hasPrefix "asusd/" name) config.environment.etc);

    environment.etc = lib.mapAttrs' (
      name: value:
      lib.nameValuePair (configPath name) (
        (if value.source != null then { source = value.source; } else { text = value.text; })
        // {
          mode = "0644";
        }
      )
    ) managedConfigFiles;

    systemd.services.asusd = lib.mkIf (managedConfigFiles != { }) {
      preStart = lib.mkIf cfg.restoreConfigs (
        lib.concatMapStringsSep "\n" (
          name:
          let
            path = configPath name;
          in
          ''
            ${lib.getExe' pkgs.coreutils "install"} -m 0644 -- ${
              lib.escapeShellArg (toString config.environment.etc.${path}.source)
            } ${lib.escapeShellArg "/etc/${path}"}
          ''
        ) (lib.attrNames managedConfigFiles)
      );
      restartTriggers = map (name: config.environment.etc.${configPath name}.source) (
        lib.attrNames managedConfigFiles
      );
    };

    services.dbus.enable = true;
    systemd.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };

  meta.maintainers = pkgs.asusctl.meta.maintainers;
}
