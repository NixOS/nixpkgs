{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gitweb;

in
{

  options.services.gitweb = {

    projectroot = lib.mkOption {
      default = "/srv/git";
      type = lib.types.path;
      description = ''
        Path to git projects (bare repositories) that should be served by
        gitweb. Must not end with a slash.
      '';
    };

    extraConfig = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = ''
        Verbatim configuration text appended to the generated gitweb.conf file.
      '';
      example = ''
        $feature{'highlight'}{'default'} = [1];
        $feature{'ctags'}{'default'} = [1];
        $feature{'avatar'}{'default'} = ['gravatar'];
        $feature{'pathinfo'}{'default'} = [1];
      '';
    };

    gitwebTheme = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Use an alternative theme for gitweb, strongly inspired by GitHub.
      '';
    };

    gitwebConfigFile = lib.mkOption {
      default = pkgs.writeText "gitweb.conf" ''
        # path to git projects (<project>.git)
        $projectroot = "${cfg.projectroot}";
        $highlight_bin = "${pkgs.highlight}/bin/highlight";
        ${cfg.extraConfig}
      '';
      defaultText = lib.literalMD "generated config file";
      type = lib.types.path;
      readOnly = true;
      internal = true;
    };

  };

  meta.maintainers = [ ];

}
