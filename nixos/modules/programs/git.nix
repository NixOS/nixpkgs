{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.git;
in

{
  options = {
    programs.git = {
      enable = mkEnableOption "git";

      package = mkOption {
        type = types.package;
        default = pkgs.git;
        defaultText = "pkgs.git";
        example = literalExample "pkgs.gitFull";
        description = "The git package to use";
      };

      config = mkOption {
        type = types.attrs;
        default = { };
        example = {
          init.defaultBranch = "main";
          url."https://github.com/".insteadOf = [ "gh:" "github:" ];
        };
        description = ''
          Configuration to write to /etc/gitconfig. See the CONFIGURATION FILE
          section of git-config(1) for more information.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.etc.gitconfig = mkIf (cfg.config != {}) {
      text = generators.toGitINI cfg.config;
    };
  };

  meta.maintainers = with maintainers; [ figsoda ];
}
