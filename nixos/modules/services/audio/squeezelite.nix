{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.squeezelite;

  serviceDeps = [
    "network.target"
    "sound.target"
  ]
  ++ lib.optionals cfg.pulseaudio.enable (
    if config.services.pulseaudio.systemWide then
      [ "pulseaudio.service" ]
    else
      [
        "pipewire.service"
        "pipewire-pulse.socket"
      ]
  );

in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "squeezelite" "pulseAudio" ]
      [ "services" "squeezelite" "pulseaudio" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "squeezelite" "extraArguments" ]
      [ "services" "squeezelite" "extraArgs" ]
    )
  ];

  options.services.squeezelite = {
    enable = lib.mkEnableOption "Squeezelite, a software Squeezebox emulator";

    package = lib.mkPackageOption pkgs "squeezelite" { } // {
      default = if cfg.pulseaudio.enable then pkgs.squeezelite-pulse else pkgs.squeezelite;
      defaultText = lib.literalExpression "if config.services.squeezelite.pulseaudio.enable then pkgs.squeezelite-pulse else pkgs.squeezelite";
    };

    name = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "name to report to server";
      default = null;
    };

    mutableName = lib.mkOption {
      type = lib.types.bool;
      description = "store name in file, controllable by server";
      default = cfg.name == null;
      defaultText = lib.literalExpression "config.services.squeezelite.name == null";
    };

    pulseaudio = {
      enable = lib.mkEnableOption "pulseaudio support";
      group = lib.mkOption {
        type = lib.types.str;
        description = "group for accessing to pulseaudio socket";
        default = if config.services.pulseaudio.systemWide then "pulse-access" else "pipewire";
        defaultText = lib.literalExpression ''if config.services.pulseaudio.systemWide then "pulse-access" else "pipewire"'';
      };
    };

    extraArgs = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = ''
        Additional command line arguments to pass to Squeezelite.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.name == null || !cfg.mutableName;
        message = "'services.squeezelite.name' and 'services.squeezelite.mutableName' are mutually exclusive";
      }
      {
        assertion =
          !cfg.pulseaudio.enable
          || (
            (config.services.pulseaudio.enable && config.services.pulseaudio.systemWide)
            || (
              config.services.pipewire.enable
              && config.services.pipewire.pulse.enable
              && config.services.pipewire.systemWide
            )
          );
        message = ''
          `services.squeezelite.pulseaudio.enable = true' requires a system-wide Pulseaudio server. Either:
          - `services.pulseaudio.enable = true' and `services.pulseaudio.systemWide = true'
          or
          - `services.pipewire.enable = true', `services.pipewire.pulse.enable = true', and `services.pipewire.systemWide = true'
          should be set.
        '';
      }
    ];

    systemd.services.squeezelite = {
      wantedBy = [
        "multi-user.target"
        # try and start squeezelite if it isn't already, e.g. a sound card plugged in
        "sound.target"
      ];
      after = serviceDeps;
      requires = serviceDeps;
      description = "Software Squeezebox emulator";

      environment = {
        XDG_CONFIG_HOME = "%S/squeezelite/.config";
        XDG_RUNTIME_DIR = "%t/squeezelite";
      };

      serviceConfig = {
        ExecStartPre = [
          # print available interfaces
          "${lib.getExe cfg.package} -l"
        ]
        ++ lib.optionals (!cfg.pulseaudio.enable) [
          # print available alsa controls
          "${lib.getExe cfg.package} -L"
        ];
        ExecStart = "${lib.getExe cfg.package} ${
          lib.optionalString (cfg.name != null) "-n ${cfg.name} "
        }${lib.optionalString cfg.mutableName "-N %S/squeezelite/player-name "}${cfg.extraArgs}";

        DynamicUser = true;
        RuntimeDirectory = "squeezelite";
        RuntimeDirectoryMode = "0700";
        StateDirectory = "squeezelite";
        StateDirectoryMode = "0700";
        SupplementaryGroups = [
          "audio"
        ]
        ++ lib.optionals cfg.pulseaudio.enable [
          cfg.pulseaudio.group
        ];
        TimeoutStopSec = "5";
      };
    };
  };
}
