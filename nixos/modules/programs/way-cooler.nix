{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.way-cooler;
  way-cooler = pkgs.way-cooler;

  wcWrapped = pkgs.writeShellScriptBin "way-cooler" ''
    ${cfg.extraSessionCommands}
    exec ${pkgs.dbus}/bin/dbus-run-session ${way-cooler}/bin/way-cooler
  '';
  wcJoined = pkgs.symlinkJoin {
    name = "way-cooler-wrapped";
    paths = [ wcWrapped way-cooler ];
  };
  configFile = readFile "${way-cooler}/etc/way-cooler/init.lua";
  spawnBar = ''
    util.program.spawn_at_startup("lemonbar");
  '';
in
{
  options.programs.way-cooler = {
    enable = mkEnableOption "way-cooler";

    extraSessionCommands = mkOption {
      default     = "";
      type        = types.lines;
      example = ''
        export XKB_DEFAULT_LAYOUT=us,de
        export XKB_DEFAULT_VARIANT=,nodeadkeys
        export XKB_DEFAULT_OPTIONS=grp:caps_toggle,
      '';
      description = ''
        Shell commands executed just before way-cooler is started.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        westonLite xwayland dmenu
      ];
      example = literalExample ''
        with pkgs; [
          westonLite xwayland dmenu
        ]
      '';
      description = ''
        Extra packages to be installed system wide.
      '';
    };

    enableBar = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable an unofficial bar.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ wcJoined ] ++ cfg.extraPackages;

    security.pam.services.wc-lock = {};
    environment.etc."way-cooler/init.lua".text = ''
      ${configFile}
      ${optionalString cfg.enableBar spawnBar}
    '';

    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultFonts = mkDefault true;
    programs.dconf.enable = mkDefault true;
  };

  meta.maintainers = with maintainers; [ gnidorah ];
}
