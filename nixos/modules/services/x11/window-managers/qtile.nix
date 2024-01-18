{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.qtile;
  pyEnv = pkgs.python3.withPackages (p: [ (cfg.package.unwrapped or cfg.package) ] ++ (cfg.extraPackages p));
in

{
  options.services.xserver.windowManager.qtile = {
    enable = mkEnableOption (lib.mdDoc "qtile");

    package = mkPackageOption pkgs "qtile-unwrapped" { };

    configFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = literalExpression "./your_config.py";
      description = lib.mdDoc ''
          Path to the qtile configuration file.
          If null, $XDG_CONFIG_HOME/qtile/config.py will be used.
      '';
    };

    backend = mkOption {
      type = types.enum [ "x11" "wayland" ];
      default = "x11";
      description = lib.mdDoc ''
          Backend to use in qtile: `x11` or `wayland`.
      '';
    };

    extraPackages = mkOption {
        type = types.functionTo (types.listOf types.package);
        default = _: [];
        defaultText = literalExpression ''
          python3Packages: with python3Packages; [];
        '';
        description = lib.mdDoc ''
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
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = [{
      name = "qtile";
      start = ''
        ${pyEnv}/bin/qtile start -b ${cfg.backend} \
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
