{ config, pkgs, lib, ... }:

with lib;

let
  prg = config.programs;
  cfg = prg.thefuck;

  bashAndZshInitScript = ''
    eval $(${pkgs.thefuck}/bin/thefuck --alias ${cfg.alias})
  '';
  fishInitScript = ''
    ${pkgs.thefuck}/bin/thefuck --alias ${cfg.alias} | source
  '';
in
  {
    options = {
      programs.thefuck = {
        enable = mkEnableOption "thefuck";

        alias = mkOption {
          default = "fuck";
          type = types.str;

          description = ''
            `thefuck` needs an alias to be configured.
            The default value is `fuck`, but you can use anything else as well.
          '';
        };
        recursive = mkEnableOption "recursively applying rules until the command runs";
        noConfirm = mkEnableOption "applying rules automatically, without any user confirmation";
        instantMode = mkEnableOption ''
          the experimental instant mode, that reduces evaluation times by logging shell output
          instead of re-running the command itself
        '';
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ thefuck ];
      environment.shellPkgs = [(pkgs.thefuck.mkShellPkg cfg)];
    };
  }
