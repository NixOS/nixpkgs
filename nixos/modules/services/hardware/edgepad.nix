{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.edgepad;
  format = pkgs.formats.toml { };
  configFile = user: "edgepad/${user}.toml";
  userConfig = "/etc/${configFile "%u"}";
  hasBindings = bindings: builtins.isList bindings && bindings != [ ];
in
{
  meta = {
    maintainers = [ lib.maintainers.assembledev ];
    doc = ./edgepad.md;
  };

  options.services.edgepad = {
    enable = lib.mkEnableOption "Edgepad touchpad edge gestures";
    package = lib.mkPackageOption pkgs "edgepad" { };

    users = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options.settings = lib.mkOption {
            type = format.type;
            default = { };
            example = {
              device = "auto";
              gestures = [
                {
                  zone = "left";
                  direction = "tap";
                  action = [
                    "notify-send"
                    "Edgepad"
                  ];
                }
              ];
            };
            description = ''
              Edgepad TOML settings for this user. The generated file is in the
              Nix store and can be read by other users.
            '';
          };
        }
      );
      default = { };
      description = "Normal local users for whom Edgepad starts in the graphical session.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.users != { };
        message = "services.edgepad.users must configure at least one user.";
      }
      {
        assertion = lib.all (user: config.users.users.${user}.isNormalUser or false) (
          lib.attrNames cfg.users
        );
        message = "services.edgepad.users must refer to normal users defined in users.users.";
      }
    ]
    ++ lib.mapAttrsToList (user: userCfg: {
      assertion =
        hasBindings (userCfg.settings.gestures or [ ]) || hasBindings (userCfg.settings.sliders or [ ]);
      message = "services.edgepad.users.${user}.settings must define at least one gesture or slider.";
    }) cfg.users;

    boot.kernelModules = [ "uinput" ];
    services.udev.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];

    environment.etc = lib.mapAttrs' (
      user: userCfg:
      lib.nameValuePair (configFile user) {
        source = format.generate "edgepad-${user}.toml" userCfg.settings;
      }
    ) cfg.users;

    systemd.user.services.edgepad = {
      description = "Edgepad touchpad edge gesture daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      unitConfig.ConditionPathExists = userConfig;
      restartTriggers = lib.mapAttrsToList (
        user: _: config.environment.etc.${configFile user}.source
      ) cfg.users;

      serviceConfig = {
        Type = "notify";
        NotifyAccess = "main";
        ExecStart = "${lib.getExe cfg.package} daemon --config ${userConfig}";
        TimeoutStartSec = "45s";
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}
