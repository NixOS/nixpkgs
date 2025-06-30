{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.npm;
in

{
  ###### interface

  options = {
    programs.npm = {
      enable = lib.mkEnableOption "{command}`npm` global config";

      package = lib.mkPackageOption pkgs [ "nodePackages" "npm" ] {
        example = "nodePackages_13_x.npm";
      };

      npmrc = lib.mkOption {
        type = lib.types.lines;
        description = ''
          The system-wide npm configuration.
          See <https://docs.npmjs.com/misc/config>.
        '';
        default = ''
          prefix = ''${HOME}/.npm
        '';
        example = ''
          prefix = ''${HOME}/.npm
          https-proxy=proxy.example.com
          init-license=MIT
          init-author-url=https://www.npmjs.com/
          color=true
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.etc.npmrc.text = cfg.npmrc;

    environment.variables.NPM_CONFIG_GLOBALCONFIG = "/etc/npmrc";

    environment.systemPackages = [ cfg.package ];
  };

}
