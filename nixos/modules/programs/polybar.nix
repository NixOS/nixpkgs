{ config, lib, pkgs, ... }:

{
  options.programs.polybar = with lib; {

    enable =
      mkEnableOption "Whether to enable <command>polybar</command> system-wide."
      // {
        relatedPackages = [ "polybar" ];
      };

    package = mkOption {
      default = pkgs.polybar;
      defaultText = "pkgs.polybar";
      description = ''
        The <command>polybar</command> package to enable.
        This is where the package can be customized.
      '';
      example = literalExample ''
        pkgs.polybar.override {
          mpdSupport = true;
          i3Support = true;
        }
      '';
    };

  };

  config = let cfg = config.programs.polybar;
  in lib.mkIf cfg.enable {

    fonts.fonts = [ pkgs.siji ];
    # default polybar font containing indicator pictographs

    environment.systemPackages = [ cfg.package ];

  };

  meta.maintainers = [ lib.maintainers.ehmry ];
}
