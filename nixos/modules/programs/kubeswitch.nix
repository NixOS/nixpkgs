{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.kubeswitch;
in
  {
    options = {
      programs.kubeswitch = {
        enable = mkEnableOption (lib.mdDoc "kubeswitch");

        command_name = mkOption {
          type = types.str;
          default = "kswitch";
          description = "The name of the command to use";
        };
        
        package = mkOption {
          type = types.package;
          default = pkgs.kubeswitch;
          description = "The package to install for kubeswitch";
        };
      };
    };

    config =
      let
        shell_files = pkgs.stdenv.mkDerivation rec {
          name = "kubeswitch-shell-files";
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p $out/share
            for shell in bash zsh; do
              ${cfg.package}/bin/switcher init $shell | sed 's/switch(/${cfg.command_name}(/' > $out/share/${cfg.command_name}_init.$shell
              ${cfg.package}/bin/switcher --cmd ${cfg.command_name} completion $shell > $out/share/${cfg.command_name}_completion.$shell
            done
          '';
        };
      in
      mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];

        programs.bash.interactiveShellInit = ''
          source ${shell_files}/share/${cfg.command_name}_init.bash
          source ${shell_files}/share/${cfg.command_name}_completion.bash
        '';
        programs.zsh.interactiveShellInit = ''
          source ${shell_files}/share/${cfg.command_name}_init.zsh
          source ${shell_files}/share/${cfg.command_name}_completion.zsh
        '';
    };
  }
