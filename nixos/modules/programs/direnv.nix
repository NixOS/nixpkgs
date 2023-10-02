{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.direnv;
in {
  options.programs.direnv = {

    enable = lib.mkEnableOption (lib.mdDoc ''
      direnv integration. Takes care of both installation and
      setting up the sourcing of the shell. Additionally enables nix-direnv
      integration. Note that you need to logout and login for this change to apply.
    '');

    package = lib.mkPackageOptionMD pkgs "direnv" {};

    direnvrcExtra = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = ''
        export FOO="foo"
        echo "loaded direnv!"
      '';
      description = lib.mdDoc ''
        Extra lines to append to the sourced direnvrc
      '';
    };

    silent = lib.mkEnableOption (lib.mdDoc ''
      the hiding of direnv logging
    '');

    loadInNixShell =
      lib.mkEnableOption (lib.mdDoc ''
        loading direnv in `nix-shell` `nix shell` or `nix develop`
      '')
      // {
        default = true;
      };

    nix-direnv = {
      enable =
        (lib.mkEnableOption (lib.mdDoc ''
          a faster, persistent implementation of use_nix and use_flake, to replace the built-in one
        ''))
        // {
          default = true;
        };

      package = lib.mkPackageOptionMD pkgs "nix-direnv" {};
    };
  };

  imports = [
    (lib.mkRemovedOptionModule ["programs" "direnv" "persistDerivations"] "persistDerivations was removed as it is on longer necessary")
  ];

  config = lib.mkIf cfg.enable {

    programs = {
      zsh.interactiveShellInit = ''
        if ${lib.boolToString cfg.loadInNixShell} || printenv PATH | grep -vqc '/nix/store'; then
         eval "$(${lib.getExe cfg.package} hook zsh)"
        fi
      '';

      #$NIX_GCROOT for "nix develop" https://github.com/NixOS/nix/blob/6db66ebfc55769edd0c6bc70fcbd76246d4d26e0/src/nix/develop.cc#L530
      #$IN_NIX_SHELL for "nix-shell"
      bash.interactiveShellInit = ''
        if ${lib.boolToString cfg.loadInNixShell} || [ -z "$IN_NIX_SHELL$NIX_GCROOT$(printenv PATH | grep '/nix/store')" ] ; then
         eval "$(${lib.getExe cfg.package} hook bash)"
        fi
      '';

      fish.interactiveShellInit = ''
        if ${lib.boolToString cfg.loadInNixShell};
        or printenv PATH | grep -vqc '/nix/store';
         ${lib.getExe cfg.package} hook fish | source
        end
      '';
    };

    environment = {
      systemPackages =
        if cfg.loadInNixShell then [cfg.package]
        else [
          #direnv has a fish library which sources direnv for some reason
          (cfg.package.overrideAttrs (old: {
            installPhase =
              (old.installPhase or "")
              + ''
                rm -rf $out/share/fish
              '';
          }))
        ];

      variables = {
        DIRENV_CONFIG = "/etc/direnv";
        DIRENV_LOG_FORMAT = lib.mkIf cfg.silent "";
      };

      etc = {
        "direnv/direnvrc".text = ''
          ${lib.optionalString cfg.nix-direnv.enable ''
            #Load nix-direnv
            source ${cfg.nix-direnv.package}/share/nix-direnv/direnvrc
          ''}

           #Load direnvrcExtra
           ${cfg.direnvrcExtra}

           #Load user-configuration if present (~/.direnvrc or ~/.config/direnv/direnvrc)
           direnv_config_dir_home="''${DIRENV_CONFIG_HOME:-''${XDG_CONFIG_HOME:-$HOME/.config}/direnv}"
           if [[ -f $direnv_config_dir_home/direnvrc ]]; then
             source "$direnv_config_dir_home/direnvrc" >&2
           elif [[ -f $HOME/.direnvrc ]]; then
             source "$HOME/.direnvrc" >&2
           fi

           unset direnv_config_dir_home
        '';

        "direnv/lib/zz-user.sh".text = ''
          direnv_config_dir_home="''${DIRENV_CONFIG_HOME:-''${XDG_CONFIG_HOME:-$HOME/.config}/direnv}"

          for lib in "$direnv_config_dir_home/lib/"*.sh; do
            source "$lib"
          done

          unset direnv_config_dir_home
        '';
      };
    };
  };
}
