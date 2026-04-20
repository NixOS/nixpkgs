{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkPackageOption
    optional
    optionals
    types
    ;

  cfg = config.services.kmscon;

  gettyCfg = config.services.getty;

  configDir = pkgs.writeTextFile {
    name = "kmscon-config";
    destination = "/kmscon.conf";
    text = cfg.extraConfig;
  };

  baseLoginOptions = "-p -- \\u";

  agettyCmd =
    enableAutologin:
    "${lib.getExe' pkgs.util-linux "agetty"} ${
      lib.escapeShellArgs (
        [
          "--login-program"
          (toString gettyCfg.loginProgram)
          "--login-options"
          # these options are passed as a single parameter
          "${lib.optionalString enableAutologin "-f "}${baseLoginOptions}"
        ]
        ++ lib.optionals enableAutologin [
          "--autologin"
          gettyCfg.autologinUser
        ]
        ++ gettyCfg.extraArgs
        ++ [
          "--8bits"
          "--noclear"
          "--"
          "-"
        ]
      )
    } $TERM";

  loginScript = pkgs.writers.writeDash "kmscon-login" ''
    kms_tty=
    active_tty_file=/sys/class/tty/tty0/active
    if [ -f "$active_tty_file" ]; then
      read -r kms_tty < "$active_tty_file"
    fi

    ${lib.optionalString (gettyCfg.autologinUser != null && gettyCfg.autologinOnce) ''
      autologged="/run/kmscon.autologged"
      if [ "$kms_tty" = tty1 ] && [ ! -f "$autologged" ]; then
        touch "$autologged"
        exec ${agettyCmd true}
      fi
    ''}

    exec ${agettyCmd (gettyCfg.autologinUser != null && !gettyCfg.autologinOnce)}
  '';
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "kmscon" "autologinUser" ] ''
      Autologin is now handled by the agetty module.

      Check `services.getty.autologinUser` instead.
    '')
  ];

  options = {
    services.kmscon = {
      enable = mkEnableOption ''
        Use kmscon instead of autovt.

        Kmscon is a simple terminal emulator based on linux kernel mode setting (KMS).
        It is an attempt to replace the in-kernel VT implementation with a userspace console.
      '';

      package = mkPackageOption pkgs "kmscon" { };

      hwRender = mkEnableOption "3D hardware acceleration to render the console";

      fonts = mkOption {
        description = "Fonts used by kmscon, in order of priority.";
        default = null;
        example = lib.literalExpression ''[ { name = "Source Code Pro"; package = pkgs.source-code-pro; } ]'';
        type =
          with types;
          let
            fontType = submodule {
              options = {
                name = mkOption {
                  type = str;
                  description = "Font name, as used by fontconfig.";
                };
                package = mkOption {
                  type = package;
                  description = "Package providing the font.";
                };
              };
            };
          in
          nullOr (nonEmptyListOf fontType);
      };

      useXkbConfig = mkEnableOption "configure keymap from xserver keyboard settings.";

      term = mkOption {
        description = "Value for the TERM environment variable.";
        type = types.nullOr types.str;
        default = null;
        example = "xterm-256color";
      };

      extraConfig = mkOption {
        description = "Extra contents of the kmscon.conf file.";
        type = types.lines;
        default = "";
        example = "font-size=14";
      };

      extraOptions = mkOption {
        description = "Extra flags to pass to kmscon.";
        type = types.separatedString " ";
        default = "";
        example = "--term xterm-256color";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = gettyCfg.loginOptions == null;
        message = "services.getty.loginOptions is not supported when services.kmscon is enabled.";
      }
    ];

    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    systemd.services."kmsconvt@" = {
      serviceConfig.ExecStart = [
        "" # override upstream default with an empty ExecStart
        (builtins.concatStringsSep " " (
          [
            "${cfg.package}/bin/kmscon"
            "--configdir"
            configDir
            "--vt=%I"
            "--no-switchvt"
            "--login"
          ]
          ++ lib.optional (cfg.extraOptions != "") cfg.extraOptions
          ++ [
            "--"
            loginScript
          ]
        ))
      ];

      restartIfChanged = false;
      aliases = [ "autovt@.service" ];
    };

    systemd.suppressedSystemUnits = [ "autovt@.service" ];

    services.kmscon.extraConfig =
      let
        xkb = optionals cfg.useXkbConfig (
          lib.mapAttrsToList (n: v: "xkb-${n}=${v}") (
            lib.filterAttrs (
              n: v:
              builtins.elem n [
                "layout"
                "model"
                "options"
                "variant"
              ]
              && v != ""
            ) config.services.xserver.xkb
          )
        );
        render = optionals cfg.hwRender [
          "drm"
          "hwaccel"
        ];
        fonts =
          optional (cfg.fonts != null)
            "font-name=${lib.concatMapStringsSep ", " (f: f.name) cfg.fonts}";
        term = optional (cfg.term != null) "term=${cfg.term}";
      in
      lib.concatLines (xkb ++ render ++ fonts ++ term);

    hardware.graphics.enable = mkIf cfg.hwRender true;

    fonts = mkIf (cfg.fonts != null) {
      fontconfig.enable = true;
      packages = map (f: f.package) cfg.fonts;
    };
  };

  meta.maintainers = with lib.maintainers; [
    hustlerone
    ccicnce113424
  ];
}
