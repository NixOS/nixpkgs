{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.sing-box-for-desktop;

  nullableBool = lib.types.nullOr lib.types.bool;
  nullableString = lib.types.nullOr lib.types.str;
  nullablePositiveInt = lib.types.nullOr lib.types.ints.positive;

  profileType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.strMatching ".+";
        description = "Profile display name and stable declarative identifier.";
      };

      configurationPath = lib.mkOption {
        type = lib.types.strMatching "/.+";
        description = ''
          Absolute runtime path to a sing-box JSON configuration. Only the path
          is stored in the Nix store; the desktop process reads the file when it
          starts. Use a plain string such as /run/secrets/sing-box.json rather
          than a Nix path literal, which would copy the file into the Nix store.
        '';
      };
    };
  };

  configuredProfiles = if cfg.profiles == null then [ ] else cfg.profiles;
  profileNames = map (profile: profile.name) configuredProfiles;
  profileId = name: builtins.hashString "sha256" name;

  managedPreferences = lib.filterAttrs (_: value: value != null) {
    tray_enabled = cfg.settings.tray.enable;
    tray_in_background = cfg.settings.tray.keepInBackground;
    language = if cfg.settings.language == "auto" then null else cfg.settings.language;
    theme = cfg.settings.appearance;
    accent = if cfg.settings.theme == "default" then null else cfg.settings.theme;
    disable-deprecated-warnings = cfg.settings.core.disableDeprecatedWarnings;
  };

  managedPreferenceRemovals =
    lib.optionals (cfg.settings.language == "auto") [ "language" ]
    ++ lib.optionals (cfg.settings.theme == "default") [ "accent" ];

  managedTerminalConfiguration = lib.filterAttrs (_: value: value != null) {
    symbolBarAlwaysShow = cfg.settings.terminal.alwaysShowSymbolBar;
    lightThemeName = cfg.settings.terminal.lightTheme;
    darkThemeName = cfg.settings.terminal.darkTheme;
    lightThemeCustom =
      if cfg.settings.terminal.lightCustomTheme == null then
        null
      else
        builtins.toJSON cfg.settings.terminal.lightCustomTheme;
    darkThemeCustom =
      if cfg.settings.terminal.darkCustomTheme == null then
        null
      else
        builtins.toJSON cfg.settings.terminal.darkCustomTheme;
    fontFamily = cfg.settings.terminal.fontFamily;
    fontSize = cfg.settings.terminal.fontSize;
  };

  managedConfiguration = {
    version = 1;
    preferences = managedPreferences;
    removePreferences = managedPreferenceRemovals;
    terminal = managedTerminalConfiguration;
  }
  // lib.optionalAttrs (cfg.settings.startAtLogin != null) {
    openAtLogin = cfg.settings.startAtLogin;
  }
  // lib.optionalAttrs (cfg.profiles != null) {
    profiles = map (profile: {
      id = profileId profile.name;
      inherit (profile) name configurationPath;
    }) configuredProfiles;
  }
  // lib.optionalAttrs (cfg.defaultProfile != null) {
    selectedProfileId = profileId cfg.defaultProfile;
  };

  managedConfigurationFile = pkgs.writeText "sing-box-managed-configuration.json" (
    builtins.toJSON managedConfiguration
  );
  managedOpenAtLogin =
    if cfg.settings.startAtLogin == null then
      ""
    else if cfg.settings.startAtLogin then
      "true"
    else
      "false";

  configuredPackage = pkgs.symlinkJoin {
    name = "sing-box-for-desktop-configured";
    paths = [ cfg.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/sing-box" \
        --set SING_BOX_LAUNCHER "$out/bin/sing-box" \
        --set SING_BOX_MANAGED_OPEN_AT_LOGIN "${managedOpenAtLogin}" \
        --set SING_BOX_MANAGED_CONFIGURATION "${managedConfigurationFile}"
    '';
    inherit (cfg.package) meta;
  };

  daemon = "${cfg.package}/share/sing-box-for-desktop/resources/daemon/sing-box-daemon";
  runtimeDirectory = "sing-box-daemon";
  workingDirectory = "/var/lib/sing-box-daemon";
  socketPath = "/run/${runtimeDirectory}/sing-box.socket";
in
{
  meta.maintainers = with lib.maintainers; [ snemeow ];

  options.programs.sing-box-for-desktop = {
    enable = lib.mkEnableOption "the sing-box Linux desktop client and its system daemon";

    package = lib.mkPackageOption pkgs "sing-box-for-desktop" { };

    settings = {
      startAtLogin = lib.mkOption {
        type = nullableBool;
        default = null;
        description = ''
          Whether to start sing-box-for-desktop when a graphical session
          starts. Null leaves the application's per-user setting unmanaged.
        '';
      };

      tray = {
        enable = lib.mkOption {
          type = nullableBool;
          default = null;
          description = "Whether to enable the desktop tray icon. Null leaves it unmanaged.";
        };

        keepInBackground = lib.mkOption {
          type = nullableBool;
          default = null;
          description = ''
            Whether closing the final window keeps the tray process running.
            Null leaves the application setting unmanaged.
          '';
        };
      };

      language = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "auto"
            "en"
            "zh-Hans"
            "zh-Hant"
            "fa"
            "ru"
          ]
        );
        default = null;
        description = "Desktop language. Null leaves it unmanaged; auto follows the session locale.";
      };

      appearance = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "auto"
            "light"
            "dark"
          ]
        );
        default = null;
        description = "Light/dark appearance. Null leaves it unmanaged.";
      };

      theme = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.strMatching "(default|blue|purple|pink|red|orange|yellow|green|graphite|#[0-9a-f]{6})"
        );
        default = null;
        description = "Accent theme preset or lowercase #rrggbb color. Null leaves it unmanaged.";
      };

      terminal = {
        lightTheme = lib.mkOption {
          type = nullableString;
          default = null;
          description = "Light terminal theme name; an empty string selects the custom theme.";
        };

        darkTheme = lib.mkOption {
          type = nullableString;
          default = null;
          description = "Dark terminal theme name; an empty string selects the custom theme.";
        };

        lightCustomTheme = lib.mkOption {
          type = lib.types.nullOr lib.types.attrs;
          default = null;
          description = "Custom light xterm.js theme encoded as JSON. Null leaves it unmanaged.";
        };

        darkCustomTheme = lib.mkOption {
          type = lib.types.nullOr lib.types.attrs;
          default = null;
          description = "Custom dark xterm.js theme encoded as JSON. Null leaves it unmanaged.";
        };

        fontFamily = lib.mkOption {
          type = nullableString;
          default = null;
          description = "Terminal font family. Null leaves it unmanaged.";
        };

        fontSize = lib.mkOption {
          type = nullablePositiveInt;
          default = null;
          description = "Terminal font size in pixels. Null leaves it unmanaged.";
        };

        alwaysShowSymbolBar = lib.mkOption {
          type = nullableBool;
          default = null;
          description = "Whether to always show the terminal symbol bar. Null leaves it unmanaged.";
        };
      };

      core = {
        insecureMode = lib.mkOption {
          type = nullableBool;
          default = null;
          description = ''
            Whether the privileged daemon permits configurations to use
            privileges unrelated to networking. Null preserves the runtime
            setting; a boolean reapplies the value whenever the service starts.
          '';
        };

        disableDeprecatedWarnings = lib.mkOption {
          type = nullableBool;
          default = null;
          description = "Whether to suppress deprecated-feature warnings. Null leaves it unmanaged.";
        };
      };
    };

    profiles = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf profileType);
      default = null;
      description = ''
        Ordered declarative profile list. Null preserves all user-managed
        profiles; a list replaces them on every application launch. Each
        profile configuration is read from its runtime configurationPath.
      '';
    };

    defaultProfile = lib.mkOption {
      type = nullableString;
      default = null;
      description = ''
        Name of the declarative profile selected on every application launch.
        Requires programs.sing-box-for-desktop.profiles to be set.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.length profileNames == lib.length (lib.unique profileNames);
        message = "sing-box-for-desktop declarative profile names must be unique";
      }
      {
        assertion = cfg.defaultProfile == null || cfg.profiles != null;
        message = "sing-box-for-desktop.defaultProfile requires declarative profiles";
      }
      {
        assertion = cfg.defaultProfile == null || lib.elem cfg.defaultProfile profileNames;
        message = "sing-box-for-desktop.defaultProfile must name a declarative profile";
      }
    ];

    environment.systemPackages = [ configuredPackage ];

    environment.etc."polkit-1/actions/io.nekohasekai.sfl.policy".source =
      "${cfg.package}/share/polkit-1/actions/io.nekohasekai.sfl.policy";

    environment.etc."xdg/autostart/sing-box.desktop" = lib.mkIf (cfg.settings.startAtLogin == true) {
      text = ''
        [Desktop Entry]
        Type=Application
        Version=1.0
        Name=sing-box
        Exec=${configuredPackage}/bin/sing-box --start-at-login
        Icon=sing-box
        Terminal=false
        StartupNotify=false
        X-GNOME-Autostart-enabled=true
      '';
    };

    security.polkit = {
      enable = true;
      enablePkexecWrapper = lib.mkDefault true;
    };

    systemd.services.sing-box-daemon = {
      description = "sing-box desktop service";
      documentation = [ "https://github.com/SagerNet/sing-box-for-desktop" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "dbus.service"
        "polkit.service"
      ];
      path = [
        pkgs.systemd
        pkgs.xdg-utils
      ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${daemon} run --working-directory ${workingDirectory} --socket ${socketPath}";
        RuntimeDirectory = runtimeDirectory;
        RuntimeDirectoryMode = "0755";
        StateDirectory = "sing-box-daemon";
        StateDirectoryMode = "0700";
        UMask = "0077";
        Restart = "always";
        RestartSec = 5;
        LimitNOFILE = 1048576;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      }
      // lib.optionalAttrs (cfg.settings.core.insecureMode != null) {
        ExecStartPre = "${daemon} service --working-directory ${workingDirectory} set-insecure-mode ${
          if cfg.settings.core.insecureMode then "true" else "false"
        }";
      };
    };
  };
}
