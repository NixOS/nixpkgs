{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.npm;
in

{
  ###### interface

  options = {
    programs.npm = {
      enable = mkEnableOption (lib.mdDoc "{command}`npm` global config");

      package = mkOption {
        type = types.package;
        description = lib.mdDoc "The npm package version / flavor to use";
        default = pkgs.nodePackages.npm;
        defaultText = literalExpression "pkgs.nodePackages.npm";
        example = literalExpression "pkgs.nodePackages_13_x.npm";
      };

      npmrc = mkOption {
        type = lib.types.lines;
        description = lib.mdDoc ''
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
          init-author-url=http://npmjs.org
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
