{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.kmscon;

  autologinArg = lib.optionalString (cfg.autologinUser != null) "-f ${cfg.autologinUser}";

  configDir = pkgs.writeTextFile {
    name = "kmscon-config";
    destination = "/kmscon.conf";
    text = cfg.extraConfig;
  };
in
{
  options = {
    services.kmscon = {
      enable = lib.mkOption {
        description = ''
          Use kmscon as the virtual console instead of gettys.
          kmscon is a kms/dri-based userspace virtual terminal implementation.
          It supports a richer feature set than the standard linux console VT,
          including full unicode support, and when the video card supports drm
          should be much faster.
        '';
        type = lib.types.bool;
        default = false;
      };

      hwRender = lib.mkOption {
        description = "Whether to use 3D hardware acceleration to render the console.";
        type = lib.types.bool;
        default = false;
      };

      fonts = lib.mkOption {
        description = "Fonts used by kmscon, in order of priority.";
        default = null;
        example = lib.literalExpression ''[ { name = "Source Code Pro"; package = pkgs.source-code-pro; } ]'';
        type =
          let
            fontType = lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Font name, as used by fontconfig.";
                };
                package = lib.mkOption {
                  type = lib.types.package;
                  description = "Package providing the font.";
                };
              };
            };
          in
          lib.types.nullOr (lib.types.nonEmptyListOf fontType);
      };

      useXkbConfig = lib.mkOption {
        description = "Configure keymap from xserver keyboard settings.";
        type = lib.types.bool;
        default = false;
      };

      extraConfig = lib.mkOption {
        description = "Extra contents of the kmscon.conf file.";
        type = lib.types.lines;
        default = "";
        example = "font-size=14";
      };

      extraOptions = lib.mkOption {
        description = "Extra flags to pass to kmscon.";
        type = lib.types.separatedString " ";
        default = "";
        example = "--term xterm-256color";
      };

      autologinUser = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Username of the account that will be automatically logged in at the console.
          If unspecified, a login prompt is shown as usual.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ pkgs.kmscon ];

    systemd.services."kmsconvt@" = {
      after = [
        "systemd-logind.service"
        "systemd-vconsole-setup.service"
      ];
      requires = [ "systemd-logind.service" ];

      serviceConfig.ExecStart = [
        ""
        ''
          ${pkgs.kmscon}/bin/kmscon "--vt=%I" ${cfg.extraOptions} --seats=seat0 --no-switchvt --configdir ${configDir} --login -- ${pkgs.shadow}/bin/login -p ${autologinArg}
        ''
      ];

      restartIfChanged = false;
      aliases = [ "autovt@.service" ];
    };

    systemd.suppressedSystemUnits = [ "autovt@.service" ];

    systemd.services.systemd-vconsole-setup.enable = false;
    systemd.services.reload-systemd-vconsole-setup.enable = false;

    services.kmscon.extraConfig =
      let
        xkb = lib.optionals cfg.useXkbConfig (
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
        render = lib.optionals cfg.hwRender [
          "drm"
          "hwaccel"
        ];
        fonts =
          lib.optional (cfg.fonts != null)
            "font-name=${lib.concatMapStringsSep ", " (f: f.name) cfg.fonts}";
      in
      lib.concatLines (xkb ++ render ++ fonts);

    hardware.graphics.enable = lib.mkIf cfg.hwRender true;

    fonts = lib.mkIf (cfg.fonts != null) {
      fontconfig.enable = true;
      packages = map (f: f.package) cfg.fonts;
    };
  };
}
