{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.programs.vlc;
in
{
  options = {
    programs.vlc = {
      enable = lib.mkEnableOption "VideoLAN's VLC media player";
      package = lib.mkPackageOption pkgs "vlc" { };

      chromecast.openFirewall = lib.mkEnableOption "" // {
        description = ''
          Open the default port (8010) in the firewall for Chromecast to work.

          Make sure to use the {package}`vlc` package with
          `chromecastSupport = true`, which is the default.
        '';
      };

      plugins = lib.mkOption {
        default = [ ];
        # TODO: List 2 plugins in the example once there are enough in nixpkgs
        example = lib.literalExpression "[ pkgs.vlc-bittorrent ]";
        type = with lib.types; listOf package;
        description = ''
          List of VLC plugins to use.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = (
      [
        cfg.package
      ]
      ++ cfg.plugins
    );

    environment.variables = lib.mkIf (cfg.plugins != [ ]) {
      # VLC_PLUGIN_PATH expects a single folder containing the user-supplied
      # plugins, not a list of directories separated by a color (:). So we
      # symlink the plugins together.
      VLC_PLUGIN_PATH = pkgs.symlinkJoin {
        name = "custom-vlc-plugins";
        paths = cfg.plugins;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.chromecast.openFirewall [
      8010
    ];
  };

  meta.maintainers = with lib.maintainers; [ kintrix ];
}
