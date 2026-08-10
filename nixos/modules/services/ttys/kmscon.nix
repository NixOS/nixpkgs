{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.kmscon;

  gettyCfg = config.services.getty;

  configDir = pkgs.writeTextFile {
    name = "kmscon-config";
    destination = "/kmscon.conf";
    text =
      let
        mkKeyValue =
          k: v: if lib.isBool v then (lib.optionalString (!v) "no-") + k else "${k}=${toString v}";
      in
      lib.generators.toKeyValue { inherit mkKeyValue; } (lib.filterAttrs (_: v: v != null) cfg.config);
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
    (lib.mkRemovedOptionModule [ "services" "kmscon" "fonts" ] ''
      `services.kmscon.fonts` is removed.

      Add your font to `fonts.packages` and configure it with
      `services.kmscon.config.font-name` instead.
    '')
    (lib.mkRemovedOptionModule [ "services" "kmscon" "extraConfig" ] ''
      `services.kmscon.extraConfig` is removed.

      Add your configurations to the new `services.kmscon.config` instead.
    '')
    (lib.mkRenamedOptionModule [ "services" "kmscon" "term" ] [ "services" "kmscon" "config" "term" ])
    (lib.mkRenamedOptionModule
      [ "services" "kmscon" "hwRender" ]
      [ "services" "kmscon" "config" "hwaccel" ]
    )
  ];

  options = {
    services.kmscon = {
      enable = mkEnableOption ''
        use kmscon instead of autovt.

        Kmscon is a simple terminal emulator based on linux kernel mode setting (KMS).
        It is an attempt to replace the in-kernel VT implementation with a userspace console
      '';

      package = mkPackageOption pkgs "kmscon" { };

      useXkbConfig = mkEnableOption ''
        configure keymap from xserver keyboard settings.

        If enabled, configurations under `services.xserver.xkb` will be injected into kmscon's configuration
      '';

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
            hwaccel = mkEnableOption "use hardware acceleration for rendering";
            libseat = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether to use libseat for session management.
                This is the default for kmscon newer than 10.0.0 and prevents
                launching another GUI from kmscon by `kmscon-launch-gui`.
              '';
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
      {
        assertion = (cfg.config ? font-name) -> config.fonts.fontconfig.enable;
        message = "Font configuration for kmscon requires fontconfig to be enabled.";
      }
      {
        assertion = cfg.config.hwaccel -> config.hardware.graphics.enable;
        message = "Hardware acceleration for kmscon requires `hardware.graphics.enable` to be true.";
      }
    ];

    services.kmscon.config = lib.mkIf cfg.useXkbConfig (
      lib.mapAttrs (_: lib.mkDefault) (
        lib.filterAttrs (_: v: v != "") {
          xkb-layout = config.services.xserver.xkb.layout;
          xkb-model = config.services.xserver.xkb.model;
          xkb-options = config.services.xserver.xkb.options;
          xkb-variant = config.services.xserver.xkb.variant;
        }
      )
    );

    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    systemd.services."kmsconvt@" = {
      serviceConfig = {
        User = lib.mkIf (!cfg.config.libseat) "";
        PAMName = lib.mkIf (!cfg.config.libseat) "";
        Environment = [ "XKB_CONFIG_ROOT=${config.services.xserver.xkb.dir}" ];
        ExecStart = [
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
      };

      restartIfChanged = false;
      # logind spawns autovt@ttyN.service on VT switch; point it at kmscon
      aliases = [ "autovt@.service" ];
    };

    # tty1 is special: logind does not spawn autovt@tty1, it expects a static
    # pull-in via getty.target. With getty@ suppressed, we must replace it.
    systemd.targets.getty.wants = lib.mkIf (!config.services.displayManager.enable) [
      "kmsconvt@tty1.service"
    ];

    systemd.suppressedSystemUnits = [ "getty@.service" ];

    security.pam.services.kmscon = lib.mkIf cfg.config.libseat {
      useDefaultRules = false;
      rules = {
        auth = utils.pam.autoOrderRules [
          {
            name = "permit";
            control = "required";
            modulePath = "${config.security.pam.package}/lib/security/pam_permit.so";
          }
        ];
        account = utils.pam.autoOrderRules [
          {
            name = "unix";
            control = "required";
            modulePath = config.security.pam.pam_unixModulePath;
          }
        ];
        session = utils.pam.autoOrderRules [
          {
            name = "env";
            control = "required";
            modulePath = "${config.security.pam.package}/lib/security/pam_env.so";
            settings = {
              conffile = "/etc/pam/environment";
              readenv = 0;
            };
          }
          {
            name = "unix";
            control = "required";
            modulePath = config.security.pam.pam_unixModulePath;
          }
          {
            name = "systemd";
            control = "optional";
            modulePath = "${config.systemd.package}/lib/security/pam_systemd.so";
            settings = {
              type = "tty";
              class = "greeter";
            };
          }
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    hustlerone
    ccicnce113424
  ];
}
