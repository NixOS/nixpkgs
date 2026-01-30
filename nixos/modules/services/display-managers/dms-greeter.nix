{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    types
    mkEnableOption
    mkOption
    mkIf
    mkDefault
    mkPackageOption
    mkRemovedOptionModule
    literalExpression
    getExe
    makeBinPath
    optionalString
    escapeShellArgs
    ;

  cfg = config.services.displayManager.dms-greeter;
  cfgAutoLogin = config.services.displayManager.autoLogin;

  cacheDir = "/var/lib/dms-greeter";

  greeterScript = pkgs.writeShellScriptBin "dms-greeter-start" ''
    export PATH=$PATH:${
      makeBinPath [
        cfg.quickshell.package
        config.programs.${cfg.compositor.name}.package
      ]
    }
    ${
      escapeShellArgs (
        [
          "sh"
          "${cfg.package}/share/quickshell/dms/Modules/Greetd/assets/dms-greeter"
          "--cache-dir"
          cacheDir
          "--command"
          cfg.compositor.name
          "-p"
          "${cfg.package}/share/quickshell/dms"
        ]
        ++ lib.optionals (cfg.compositor.customConfig != "") [
          "-C"
          "${pkgs.writeText "dmsgreeter-compositor-config" cfg.compositor.customConfig}"
        ]
      )
    } ${optionalString cfg.logs.save "> ${cfg.logs.path} 2>&1"}
  '';

  jq = getExe pkgs.jq;

  configFilesFromHome =
    if cfg.configHome != null then
      [
        "${cfg.configHome}/.config/DankMaterialShell/settings.json"
        "${cfg.configHome}/.local/state/DankMaterialShell/session.json"
        "${cfg.configHome}/.cache/DankMaterialShell/dms-colors.json"
      ]
    else
      [ ];
in
{
  options.services.displayManager.dms-greeter = {
    enable = mkEnableOption "DankMaterialShell greeter";

    package = mkPackageOption pkgs "dms-shell" { };

    compositor = {
      name = mkOption {
        type = types.enum [
          "niri"
          "hyprland"
          "sway"
        ];
        example = "niri";
        description = ''
          The Wayland compositor to run the greeter in.

          The specified compositor must be enabled via its corresponding
          `programs.<compositor>.enable` option.

          Supported compositors:
          - niri: A scrollable-tiling Wayland compositor
          - hyprland: A dynamic tiling Wayland compositor
          - sway: An i3-compatible Wayland compositor
        '';
      };

      customConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          # Niri example
          input {
              keyboard {
                  xkb {
                      layout "us"
                  }
              }
          }
        '';
        description = ''
          Custom compositor configuration to use for the greeter session.

          This configuration is written to a file and passed to the compositor
          when launching the greeter. The format and available options depend
          on the selected compositor.

          Leave empty to use the system's default compositor configuration.
        '';
      };
    };

    configFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      example = literalExpression ''
        [
          "/home/user/.config/DankMaterialShell/settings.json"
          "/home/user/.local/state/DankMaterialShell/session.json"
        ]
      '';
      description = ''
        List of DankMaterialShell configuration files to copy into the greeter
        data directory at `/var/lib/dms-greeter`.

        This is useful for preserving user preferences like wallpapers, themes,
        and other settings in the greeter screen.

        ::: {.tip}
        Use {option}`configHome` instead if your configuration files are in
        standard XDG locations.
        :::
      '';
    };

    configHome = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/home/alice";
      description = ''
        Path to a user's home directory from which to copy DankMaterialShell
        configuration files.

        When set, the following files will be automatically copied to the greeter:
        - `~/.config/DankMaterialShell/settings.json`
        - `~/.local/state/DankMaterialShell/session.json`
        - `~/.cache/DankMaterialShell/dms-colors.json`

        If your configuration files are in non-standard locations, use the
        {option}`configFiles` option instead.
      '';
    };

    quickshell = {
      package = mkPackageOption pkgs "quickshell" { };
    };

    logs = {
      save = mkEnableOption "saving logs from the DMS greeter to a file";

      path = mkOption {
        type = types.path;
        default = "/tmp/dms-greeter.log";
        example = "/var/log/dms-greeter.log";
        description = ''
          File path where DMS greeter logs will be saved.

          This is useful for debugging greeter issues. Logs will include
          output from both the greeter and the compositor.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.programs.${cfg.compositor.name}.enable or false;
        message = ''
          DankMaterialShell greeter: The compositor "${cfg.compositor.name}" is not enabled.

          Please enable the compositor via:
            programs.${cfg.compositor.name}.enable = true;
        '';
      }
    ];

    services.greetd = {
      enable = mkDefault true;
      settings = {
        default_session = {
          user = "dms-greeter";
          command = getExe greeterScript;
        };
        initial_session = mkIf (cfgAutoLogin.enable && (cfgAutoLogin.user != null)) {
          inherit (cfgAutoLogin) user command;
        };
      };
    };

    environment.systemPackages = [ cfg.package ];

    fonts.packages = with pkgs; [
      fira-code
      inter
      material-symbols
    ];

    systemd.tmpfiles.settings."10-dms-greeter".${cacheDir}.d = {
      user = "dms-greeter";
      group = "dms-greeter";
      mode = "0750";
    };

    systemd.services.greetd.preStart =
      let
        allConfigFiles = cfg.configFiles ++ configFilesFromHome;
      in
      ''
        cd ${cacheDir}
        ${lib.concatStringsSep "\n" (
          lib.map (f: ''
            if [ -f "${f}" ]; then
                cp "${f}" .
            fi
          '') allConfigFiles
        )}

        if [ -f session.json ]; then
            copy_wallpaper() {
                local path=$(${jq} -r ".$1 // empty" session.json)
                if [ -f "$path" ]; then
                    cp "$path" "$2"
                    ${jq} ".$1 = \"${cacheDir}/$2\"" session.json > session.tmp
                    mv session.tmp session.json
                fi
            }

            copy_monitor_wallpapers() {
                ${jq} -r ".$1 // {} | to_entries[] | .key + \":\" + .value" session.json 2>/dev/null | while IFS=: read monitor path; do
                    local dest="$2-$(echo "$monitor" | tr -c '[:alnum:]' '-')"
                    if [ -f "$path" ]; then
                        cp "$path" "$dest"
                        ${jq} --arg m "$monitor" --arg p "${cacheDir}/$dest" ".$1[\$m] = \$p" session.json > session.tmp
                        mv session.tmp session.json
                    fi
                done
            }

            copy_wallpaper "wallpaperPath" "wallpaper"
            copy_wallpaper "wallpaperPathLight" "wallpaper-light"
            copy_wallpaper "wallpaperPathDark" "wallpaper-dark"
            copy_monitor_wallpapers "monitorWallpapers" "wallpaper-monitor"
            copy_monitor_wallpapers "monitorWallpapersLight" "wallpaper-monitor-light"
            copy_monitor_wallpapers "monitorWallpapersDark" "wallpaper-monitor-dark"
        fi

        if [ -f settings.json ]; then
            if cp "$(${jq} -r '.customThemeFile' settings.json)" custom-theme.json; then
                mv settings.json settings.orig.json
                ${jq} '.customThemeFile = "${cacheDir}/custom-theme.json"' settings.orig.json > settings.json
            fi
        fi

        mv dms-colors.json colors.json || :
        chown dms-greeter:dms-greeter * || :
      '';

    services.displayManager.dms-greeter.configFiles = lib.mkIf (
      cfg.configHome != null
    ) configFilesFromHome;

    users.groups.dms-greeter = { };
    users.users.dms-greeter = {
      description = "DankMaterialShell greeter user";
      isSystemUser = true;
      home = cacheDir;
      homeMode = "0750";
      createHome = true;
      group = "dms-greeter";
      extraGroups = [ "video" ];
    };

    security.pam.services.dms-greeter = { };

    hardware.graphics.enable = mkDefault true;
    services.libinput.enable = mkDefault true;
  };

  meta.maintainers = lib.teams.danklinux.members;
}
