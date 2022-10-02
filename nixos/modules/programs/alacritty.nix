{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.alacritty;
in

{
  options = {
    programs.alacritty = {
      enable = mkEnableOption (lib.mdDoc "alacritty");

      package = mkOption {
        type = types.package;
        default = pkgs.alacritty;
        defaultText = literalExpression "pkgs.alacritty";
        description = lib.mdDoc "The alacritty package to use";
      };

      config = mkOption {
        type = with types; attrsOf anything;
        default = { };
        example = {
          cursor.style = "Beam";
          font.size = 8;
        };
        description = lib.mdDoc ''
          Configuration for alacritty. See
          <https://github.com/alacritty/alacritty/blob/master/alacritty.yml>
          for more information.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."xdg/alacritty/alacritty.yml".text = generators.toYAML { } cfg.config;
    };
  };

  meta.maintainers = with maintainers; [ figsoda ];
}
