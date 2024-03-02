{ config, lib, pkgs, ... }:
let
  cfg = config.programs.nix-index;
in {
  options.programs.nix-index = with lib; {
    enable = mkEnableOption (lib.mdDoc "nix-index, a file database for nixpkgs");

    package = mkPackageOption pkgs "nix-index" { };

    enableBashIntegration = mkEnableOption (lib.mdDoc "Bash integration") // {
      default = true;
    };

    enableZshIntegration = mkEnableOption (lib.mdDoc "Zsh integration") // {
      default = true;
    };

    enableFishIntegration = mkEnableOption (lib.mdDoc "Fish integration") // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = let
      checkOpt = name: {
        assertion = cfg.${name} -> !config.programs.command-not-found.enable;
        message = ''
          The 'programs.command-not-found.enable' option is mutually exclusive
          with the 'programs.nix-index.${name}' option.
        '';
      };
    in [ (checkOpt "enableBashIntegration") (checkOpt "enableZshIntegration") ];

    environment.systemPackages = [ cfg.package ];

    programs.bash.interactiveShellInit = lib.mkIf cfg.enableBashIntegration ''
      source ${cfg.package}/etc/profile.d/command-not-found.sh
    '';

    programs.zsh.interactiveShellInit = lib.mkIf cfg.enableZshIntegration ''
      source ${cfg.package}/etc/profile.d/command-not-found.sh
    '';

    # See https://github.com/bennofs/nix-index/issues/126
    programs.fish.interactiveShellInit = let
      wrapper = pkgs.writeScript "command-not-found" ''
        #!${pkgs.bash}/bin/bash
        source ${cfg.package}/etc/profile.d/command-not-found.sh
        command_not_found_handle "$@"
      '';
    in lib.mkIf cfg.enableFishIntegration ''
      function __fish_command_not_found_handler --on-event fish_command_not_found
          ${wrapper} $argv
      end
    '';
  };
}
