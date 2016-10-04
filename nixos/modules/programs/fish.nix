{ config, lib, pkgs, ... }:

with lib;

let

  cfge = config.environment;

  cfg = config.programs.fish;

  fishAliases = concatStringsSep "\n" (
    mapAttrsFlatten (k: v: "alias ${k} '${v}'") cfg.shellAliases
  );

in

{

  options = {

    programs.fish = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to configure fish as an interactive shell.
        '';
        type = types.bool;
      };

      shellAliases = mkOption {
        default = config.environment.shellAliases;
        description = ''
          Set of aliases for fish shell. See <option>environment.shellAliases</option>
          for an option format description.
        '';
        type = types.attrs;
      };

      shellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during fish shell initialisation.
        '';
        type = types.lines;
      };

      loginShellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during fish login shell initialisation.
        '';
        type = types.lines;
      };

      interactiveShellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during interactive fish shell initialisation.
        '';
        type = types.lines;
      };

      promptInit = mkOption {
        default = "";
        description = ''
          Shell script code used to initialise fish prompt.
        '';
        type = types.lines;
      };

    };

  };

  config = mkIf cfg.enable {

    environment.etc."fish/foreign-env/shellInit".text = cfge.shellInit;
    environment.etc."fish/foreign-env/loginShellInit".text = cfge.loginShellInit;
    environment.etc."fish/foreign-env/interactiveShellInit".text = cfge.interactiveShellInit;

    environment.etc."fish/config.fish".text = ''
      # /etc/fish/config.fish: DO NOT EDIT -- this file has been generated automatically.

      set fish_function_path $fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions

      fenv source ${config.system.build.setEnvironment} > /dev/null ^&1
      fenv source /etc/fish/foreign-env/shellInit > /dev/null

      ${cfg.shellInit}

      if status --is-login
        fenv source /etc/fish/foreign-env/loginShellInit > /dev/null
        ${cfg.loginShellInit}
      end

      if status --is-interactive
        ${fishAliases}
        fenv source /etc/fish/foreign-env/interactiveShellInit > /dev/null
        ${cfg.interactiveShellInit}
      end
    '';

    # include programs that bring their own completions
    environment.pathsToLink = [ "/share/fish/vendor_completions.d" ];

    environment.systemPackages = [ pkgs.fish ];

    environment.shells = [
      "/run/current-system/sw/bin/fish"
      "/var/run/current-system/sw/bin/fish"
      "${pkgs.fish}/bin/fish"
    ];

  };

}
