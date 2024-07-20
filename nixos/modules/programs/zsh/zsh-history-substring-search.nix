{ config, lib, pkgs, ... }:

let
  cfg = config.programs.zsh.history-substring-search;
in {
  options = {
    programs.zsh.history-substring-search = {
      enable = lib.mkEnableOption "zsh-history-substring-search";
      package = lib.mkPackageOption pkgs "zsh-history-substring-search" { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.interactiveShellInit = ''
      source ${cfg.package}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    '';
  };
}
