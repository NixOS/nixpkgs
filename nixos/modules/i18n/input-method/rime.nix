{ config, pkgs, lib, ... }:

let
  cfg = config.i18n.inputMethod.rime;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "i18n" "inputMethod" "fcitx5" "enableRimeData" ]
                               [ "i18n" "inputMethod" "rime" "enableDefaultRimeData" ])
  ];

  options = {
    i18n.inputMethod.rime = {
      # cfg.packages is used by different rime input method in different way,
      # currently including ibus-rime and fcitx5-rime
      packages = lib.mkOption {
        type = with lib.types; listOf package;
        default = [ ];
        description = lib.mdDoc ''
          List of RIME packages to install.
        '';
      };

      enableDefaultRimeData = lib.mkOption {
        type = with lib.types; bool;
        # default is true so that default RIME schames works out-of-box
        # expirenced users can disable it
        default = true;
        description = lib.mdDoc ''
          Whether to enable the default rime-data package.
          Default RIME schemas including luna pinyin are included in the package.
        '';
      };
    };
  };

  config = {
    # cfg.enableDefaultRimeData simply add the default rime-data package to cfg.packages
    i18n.inputMethod.rime.packages = lib.mkIf cfg.enableDefaultRimeData [
      pkgs.rime-data
    ];
  };
}
