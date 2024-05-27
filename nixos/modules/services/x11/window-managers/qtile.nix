{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.qtile;
in

{
  options.services.xserver.windowManager.qtile = {
    enable = mkEnableOption "qtile";

    package = mkPackageOption pkgs "qtile-unwrapped" { };

    configFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = literalExpression "./your_config.py";
      description = ''
          Path to the qtile configuration file.
          If null, $XDG_CONFIG_HOME/qtile/config.py will be used.
      '';
    };

    backend = mkOption {
      type = types.enum [ "x11" "wayland" ];
      default = "x11";
      description = ''
          Backend to use in qtile: `x11` or `wayland`.
      '';
    };

    extraPackages = mkOption {
        type = types.functionTo (types.listOf types.package);
        default = _: [];
        defaultText = literalExpression ''
          python3Packages: with python3Packages; [];
        '';
        description = ''
          Extra Python packages available to Qtile.
          An example would be to include `python3Packages.qtile-extras`
          for additional unofficial widgets.
        '';
        example = literalExpression ''
          python3Packages: with python3Packages; [
            qtile-extras
          ];
        '';
      };

    finalPackage = mkOption {
      type = types.package;
      visible = false;
      readOnly = true;
      description = "The resulting Qtile package, bundled with extra packages";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.qtile.finalPackage = pkgs.python3.withPackages (p:
      [ (cfg.package.unwrapped or cfg.package) ] ++ (cfg.extraPackages p)
    );

    services.xserver.windowManager.session = [{
      name = "qtile";
      start = ''
        ${cfg.finalPackage}/bin/qtile start -b ${cfg.backend} \
        ${optionalString (cfg.configFile != null)
        "--config \"${cfg.configFile}\""} &
        waitPID=$!
      '';
    }];

    environment.systemPackages = [
      # pkgs.qtile is currently a buildenv of qtile and its dependencies.
      # For userland commands, we want the underlying package so that
      # packages such as python don't bleed into userland and overwrite intended behavior.
      (cfg.package.unwrapped or cfg.package)
    ];
  };
}
