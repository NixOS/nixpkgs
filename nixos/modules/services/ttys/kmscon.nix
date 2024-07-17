{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mkIf
    mkOption
    optional
    optionals
    types
    ;

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
    # Largely copied from unit provided with kmscon source
    systemd.units."kmsconvt@.service".text = ''
      [Unit]
      Description=KMS System Console on %I
      Documentation=man:kmscon(1)
      After=systemd-user-sessions.service
      After=plymouth-quit-wait.service
      After=systemd-logind.service
      After=systemd-vconsole-setup.service
      Requires=systemd-logind.service
      Before=getty.target
      Conflicts=getty@%i.service
      OnFailure=getty@%i.service
      IgnoreOnIsolate=yes
      ConditionPathExists=/dev/tty0

      [Service]
      ExecStart=
      ExecStart=${pkgs.kmscon}/bin/kmscon "--vt=%I" ${cfg.extraOptions} --seats=seat0 --no-switchvt --configdir ${configDir} --login -- ${pkgs.shadow}/bin/login -p ${autologinArg}
      UtmpIdentifier=%I
      TTYPath=/dev/%I
      TTYReset=yes
      TTYVHangup=yes
      TTYVTDisallocate=yes

      X-RestartIfChanged=false
    '';

    systemd.suppressedSystemUnits = [ "autovt@.service" ];
    systemd.units."kmsconvt@.service".aliases = [ "autovt@.service" ];

    systemd.services.systemd-vconsole-setup.enable = false;
    systemd.services.reload-systemd-vconsole-setup.enable = false;

    services.kmscon.extraConfig =
      let
        render = optionals cfg.hwRender [
          "drm"
          "hwaccel"
        ];
        fonts =
          optional (cfg.fonts != null)
            "font-name=${lib.concatMapStringsSep ", " (f: f.name) cfg.fonts}";
      in
      lib.concatStringsSep "\n" (render ++ fonts);

    hardware.opengl.enable = mkIf cfg.hwRender true;

    fonts = mkIf (cfg.fonts != null) {
      fontconfig.enable = true;
      packages = map (f: f.package) cfg.fonts;
    };
  };
}
