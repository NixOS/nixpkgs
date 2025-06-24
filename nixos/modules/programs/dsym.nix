{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.dsym;
in {
  ###### OPTIONEN DEFINIEREN ######
  options.programs.dsym = {
    enable = mkEnableOption "Enable DSYM, a Python dotfile manager.";

    machineName = mkOption {
      type = types.str;
      default = "my-machine";
      description = "A unique identifier for this machine.";
    };

    dotfileRepo = mkOption {
      type = types.str;
      example = "https://github.com/username/dotfiles";
      description = "The URL to your dotfile Git repository.";
    };

    dotfilePath = mkOption {
      type = types.path;
      default = "/home/${config.users.users.${config.users.defaultUser}.name}/.config/";
      description = "The local path to where your dotfiles are stored.";
    };

    dsymPath = mkOption {
      type = types.path;
      default = "/home/${config.users.users.${config.users.defaultUser}.name}/dsym/";
      description = "The path where DSYM should operate or store data.";
    };
  };

  ###### KONFIGURATION ERZEUGEN ######
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.dsym ];

    environment.etc."dsym/config.ini".text = ''
      [Settings]
      machine_name = ${cfg.machineName}
      dotfile_repo = ${cfg.dotfileRepo}
      dotfile_path = ${cfg.dotfilePath}
      dsym_path = ${cfg.dsymPath}
    '';
  };
}

