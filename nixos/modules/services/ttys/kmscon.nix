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

  mkKeyValue =
    k: v:
    if true == v then
      k + "\n"
    else if false == v then
      "no-" + k + "\n"
    else
      lib.generators.mkKeyValueDefault { } "=" k v + "\n";

  configDir = pkgs.writeTextFile {
    name = "kmscon-config";
    destination = "/kmscon.conf";
    text = lib.concatStrings (
      lib.mapAttrsToList mkKeyValue (lib.filterAttrsRecursive (_: v: v != null) cfg.config)
    );
  };

  baseLoginOptions = "-p";

  loginCmd =
    enableAutologin:
    "${gettyCfg.loginProgram} ${baseLoginOptions}${lib.optionalString enableAutologin " -f -- ${gettyCfg.autologinUser}"}";

  loginScript = pkgs.writers.writeDash "kmscon-login" (
    lib.optionalString (gettyCfg.autologinUser != null && gettyCfg.autologinOnce) ''
      kms_tty=
      active_tty_file=/sys/class/tty/tty0/active
      if [ -f "$active_tty_file" ]; then
        read -r kms_tty < "$active_tty_file"
      fi

      autologged="/run/kmscon.autologged"
      if [ "$kms_tty" = tty1 ] && [ ! -f "$autologged" ]; then
        touch "$autologged"
        exec ${loginCmd true}
      fi
    ''
    + "exec ${loginCmd (gettyCfg.autologinUser != null && !gettyCfg.autologinOnce)}"
  );
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "kmscon" "autologinUser" ] ''
      Autologin is now handled by the agetty module.

      Check `services.getty.autologinUser` instead.
    '')

    (lib.mkRenamedOptionModule [ "services" "kmscon" "extraConfig" ] [ "services" "kmscon" "config" ])

    (lib.mkRenamedOptionModule [ "services" "kmscon" "term" ] [ "services" "kmscon" "config" "term" ])
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

      config = mkOption {
        description = ''
          Configuration for kmscon. See {manpage}`kmscon.conf(5)`
          for available options.
        '';
        default = { };
        type = types.submodule {
          freeformType =
            with types;
            attrsOf (oneOf [
              bool
              int
              str
            ]);

          options = {
            font-name = mkOption {
              type = types.nullOr types.str;
              default = if cfg.fonts != null then lib.concatMapStringsSep ", " (f: f.name) cfg.fonts else null;
              defaultText = lib.literalExpression ''
                if config.services.kmscon.fonts != null then
                  lib.concatMapStringsSep ", " (f: f.name) config.services.kmscon.fonts
                else
                  null
              '';
              description = "Font name to use.";
            };

            hwaccel = mkOption {
              type = types.nullOr types.bool;
              default = if cfg.hwRender then true else null;
              defaultText = lib.literalExpression ''
                if config.services.kmscon.hwRender then true else null
              '';
              description = "Use 3D hardware-acceleration if available.";
            };

            drm = mkOption {
              type = types.nullOr types.bool;
              default = if cfg.hwRender then true else null;
              defaultText = lib.literalExpression ''
                if config.services.kmscon.hwRender then true else null
              '';
              description = "Use DRM if available.";
            };

            xkb-layout = mkOption {
              type = types.nullOr types.str;
              default =
                if cfg.useXkbConfig && config.services.xserver.xkb.layout != "" then
                  config.services.xserver.xkb.layout
                else
                  null;
              defaultText = lib.literalExpression ''
                if config.services.kmscon.useXkbConfig && config.services.xserver.xkb.layout != "" then
                  config.services.xserver.xkb.layout
                else
                  null
              '';
              description = "Set XkbLayout for input devices.";
            };

            xkb-model = mkOption {
              type = types.nullOr types.str;
              default =
                if cfg.useXkbConfig && config.services.xserver.xkb.model != "" then
                  config.services.xserver.xkb.model
                else
                  null;
              defaultText = lib.literalExpression ''
                if config.services.kmscon.useXkbConfig && config.services.xserver.xkb.model != "" then
                  config.services.xserver.xkb.model
                else
                  null
              '';
              description = "Set XkbModel for input devices.";
            };

            xkb-options = mkOption {
              type = types.nullOr types.str;
              default =
                if cfg.useXkbConfig && config.services.xserver.xkb.options != "" then
                  config.services.xserver.xkb.options
                else
                  null;
              defaultText = lib.literalExpression ''
                if config.services.kmscon.useXkbConfig && config.services.xserver.xkb.options != "" then
                  config.services.xserver.xkb.options
                else
                  null
              '';
              description = "Set XkbOptions for input devices.";
            };

            xkb-variant = mkOption {
              type = types.nullOr types.str;
              default =
                if cfg.useXkbConfig && config.services.xserver.xkb.variant != "" then
                  config.services.xserver.xkb.variant
                else
                  null;
              defaultText = lib.literalExpression ''
                if config.services.kmscon.useXkbConfig && config.services.xserver.xkb.variant != "" then
                  config.services.xserver.xkb.variant
                else
                  null
              '';
              description = "Set XkbVariant for input devices.";
            };
          };
        };
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
      # logind spawns autovt@ttyN.service on VT switch; point it at kmscon
      aliases = [ "autovt@.service" ];
    };

    # tty1 is special: logind does not spawn autovt@tty1, it expects a static
    # pull-in via getty.target. With getty@ suppressed, we must replace it.
    systemd.services."getty.target".wants = lib.mkIf (!config.services.displayManager.enable) [
      "kmsconvt@tty1.service"
    ];

    systemd.suppressedSystemUnits = [ "getty@.service" ];

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
