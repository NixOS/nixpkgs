{ config, lib, pkgs, ... }:

let
  cfg = config.programs.kde-pim;
in
  {
    options.programs.kde-pim = {
      enable = lib.mkEnableOption "KDE PIM";
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs.kdePackages; [
        # core packages
        akonadi
        kdepim-runtime

        # required by kmail
        akonadiconsole
        kmail-account-wizard
      ];
    };
  }
