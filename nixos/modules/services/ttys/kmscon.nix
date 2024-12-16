{ config, pkgs, lib, ... }:
let
  inherit (lib) mapAttrs mkIf mkOption optional optionals types;

  cfg = config.services.kmscon;

  autologinArg = lib.optionalString (cfg.autologinUser != null) "-f ${cfg.autologinUser}";

  configDir = pkgs.writeTextFile { name = "kmscon-config"; destination = "/kmscon.conf"; text = cfg.extraConfig; };
in {
  options = {
    services.kmscon = {
      enable = mkOption {
        description = ''
          Use kmscon as the virtual console instead of gettys.
          kmscon is a kms/dri-based userspace virtual terminal implementation.
          It supports a richer feature set than the standard linux console VT,
          including full unicode support, and when the video card supports drm
          should be much faster.
        '';
        type = types.bool;
        default = false;
      };

      hwRender = mkOption {
        description = "Whether to use 3D hardware acceleration to render the console.";
        type = types.bool;
        default = false;
      };

      fonts = mkOption {
        description = "Fonts used by kmscon, in order of priority.";
        default = null;
        example = lib.literalExpression ''[ { name = "Source Code Pro"; package = pkgs.source-code-pro; } ]'';
        type = with types;
          let fontType = submodule {
                options = {
                  name = mkOption { type = str; description = "Font name, as used by fontconfig."; };
                  package = mkOption { type = package; description = "Package providing the font."; };
                };
          }; in nullOr (nonEmptyListOf fontType);
      };

      useXkbConfig = mkOption {
        description = "Configure keymap from xserver keyboard settings.";
        type = types.bool;
        default = false;
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

      autologinUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Username of the account that will be automatically logged in at the console.
          If unspecified, a login prompt is shown as usual.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.kmscon ];

    systemd.services."kmsconvt@" = {
      after = [ "systemd-logind.service" "systemd-vconsole-setup.service" ];
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
        xkb = optionals cfg.useXkbConfig
          (lib.mapAttrsToList (n: v: "xkb-${n}=${v}") (
            lib.filterAttrs
              (n: v: builtins.elem n ["layout" "model" "options" "variant"] && v != "")
              config.services.xserver.xkb
          ));
        render = optionals cfg.hwRender [ "drm" "hwaccel" ];
        fonts = optional (cfg.fonts != null) "font-name=${lib.concatMapStringsSep ", " (f: f.name) cfg.fonts}";
      in lib.concatLines (xkb ++ render ++ fonts);

    hardware.graphics.enable = mkIf cfg.hwRender true;

    fonts = mkIf (cfg.fonts != null) {
      fontconfig.enable = true;
      packages = map (f: f.package) cfg.fonts;
    };
  };
}
