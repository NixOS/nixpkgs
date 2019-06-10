{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.neovim;

in {
  meta.maintainers = [ maintainers.matoruru ];

  options.programs.neovim = {
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, installs neovim(nvim) and configures neovim(nvim) to be the default editor
        using the EDITOR environment variable.
      '';
    };
  };

  config = mkIf cfg.defaultEditor {
    environment.systemPackages = [ pkgs.neovim ];
    environment.variables = { EDITOR = mkOverride 900 "nvim"; };
  };
}
