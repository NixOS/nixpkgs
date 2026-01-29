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
  gettyCmd = config.services.getty.kmscon;

  configDir = pkgs.writeTextFile {
    name = "kmscon-config";
    destination = "/kmscon.conf";
    text = cfg.extraConfig;
  };
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

      hwRender = mkEnableOption "Enable hardware acceleration + DRM backend";

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

      useXkbConfig = mkEnableOption "Use XKB" // {
        description = "Whether to configure keymap from xserver keyboard settings.";
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
    meta.maintainers = with lib.maintainers; [ hustlerone ];
    systemd.packages = [
      cfg.package
    ];

    systemd.services."kmsconvt@" = {
      description = "KMS System Console on %I";
      documentation = [ "man:kmscon(1)" ];

      before = [
        "getty.target"
      ];

      after = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
        "rc-local.service"
      ];

      conflicts = [
        "getty@%i.service"
      ];

      onFailure = [
        "getty@%i.service"
      ];

      wantedBy = [
        "getty.target"
      ];

      unitConfig = {
        IgnoreOnIsolate = "yes";
        ConditionPathExists = "/dev/tty0";
      };

      serviceConfig = {
        ExecStart = "${pkgs.kmscon}/bin/kmscon --vt=%I --seats=seat0 --no-switchvt ${
          lib.optionalString (!cfg.hwRender) "--no-drm"
        } --configdir ${configDir} --login -- ${gettyCmd}";

        ## I know that usually we'd be using /bin/login directly, but this is what upstream's doing.

        UtmpIdentifier = "%I";
        TTYPath = "/dev/%I";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };

      restartIfChanged = false;
      aliases = [ "autovt@.service" ];
    };

    systemd.suppressedSystemUnits = [ "autovt@.service" ];

    systemd.services.systemd-vconsole-setup.enable = false;
    systemd.services.reload-systemd-vconsole-setup.enable = false;

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
      in
      lib.concatLines (xkb ++ render ++ fonts);

    hardware.graphics.enable = mkIf cfg.hwRender true;

    fonts = mkIf (cfg.fonts != null) {
      fontconfig.enable = true;
      packages = map (f: f.package) cfg.fonts;
    };
  };
}
