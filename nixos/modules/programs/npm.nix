{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.npm;
in

{
  ###### interface

  options = {
    programs.npm = {
      enable = mkEnableOption "<command>npm</command> global config";

      npmrc = lib.mkOption {
        type = lib.types.lines;
        description = ''
          The system-wide npm configuration.
          See <link xlink:href="https://docs.npmjs.com/misc/config"/>.
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
    environment.etc."npmrc".text = cfg.npmrc;

    environment.variables.NPM_CONFIG_GLOBALCONFIG = "/etc/npmrc";

    environment.systemPackages = [ pkgs.nodePackages.npm ];
  };

}
