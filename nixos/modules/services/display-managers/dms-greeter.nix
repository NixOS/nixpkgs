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
    literalExpression
    getExe
    makeBinPath
    optionalString
    concatMapStringsSep
    ;

  cfg = config.services.displayManager.dms-greeter;
  cfgAutoLogin = config.services.displayManager.autoLogin;

  greeterScript = pkgs.writeShellScriptBin "dms-greeter-start" ''
    export PATH=$PATH:${
      makeBinPath [
        cfg.quickshell.package
        config.programs.${cfg.compositor.name}.package
      ]
    }
    exec ${cfg.package}/share/quickshell/dms/Modules/Greetd/assets/dms-greeter \
      --command ${cfg.compositor.name} \
      -p ${cfg.package}/share/quickshell/dms \
      --cache-dir /var/lib/dms-greeter \
      ${
        optionalString (
          cfg.compositor.customConfig != ""
        ) "-C ${pkgs.writeText "dms-greeter-compositor-config" cfg.compositor.customConfig}"
      } \
      ${optionalString cfg.logs.save ">> ${cfg.logs.path} 2>&1"}
  '';

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
      enable = true;
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

    systemd.tmpfiles.settings."10-dms-greeter"."/var/lib/dms-greeter".d = {
      user = "dms-greeter";
      group = "dms-greeter";
      mode = "0750";
    };

    systemd.services.greetd.preStart =
      let
        allConfigFiles = cfg.configFiles ++ configFilesFromHome;
      in
      ''
        set -euo pipefail

        cd /var/lib/dms-greeter || exit 1

        ${concatMapStringsSep "\n" (f: ''
          if [[ -f "${f}" ]]; then
            cp "${f}" . || true
          fi
        '') allConfigFiles}

        # Handle session.json wallpaper path
        if [[ -f session.json ]]; then
          if wallpaper=$(${getExe pkgs.jq} -r '.wallpaperPath' session.json 2>/dev/null); then
            if [[ -f "$wallpaper" ]]; then
              cp "$wallpaper" wallpaper.jpg || true
              mv session.json session.orig.json
              ${getExe pkgs.jq} '.wallpaperPath = "/var/lib/dms-greeter/wallpaper.jpg"' \
                session.orig.json > session.json || true
            fi
          fi
        fi

        # Rename colors file if it exists
        [[ -f dms-colors.json ]] && mv dms-colors.json colors.json || true

        # Fix ownership of all files
        chown -R "dms-greeter:dms-greeter" . || true
      '';

    users.groups.dms-greeter = { };
    users.users.dms-greeter = {
      description = "DankMaterialShell greeter user";
      isSystemUser = true;
      home = "/var/lib/dms-greeter";
      homeMode = "0750";
      createHome = true;
      group = "dms-greeter";
      extraGroups = [ "video" ];
    };

    security.pam.services.dms-greeter = { };

    hardware.graphics.enable = mkDefault true;
    services.libinput.enable = mkDefault true;
  };

  meta.maintainers = with lib.maintainers; [ luckshiba ];
}
