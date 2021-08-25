{ config, pkgs, lib, ... }:

with lib;

let
  im = config.i18n.inputMethod;
  cfg = im.fcitx5;
  fcitx5Package = pkgs.fcitx5-with-addons.override { inherit (cfg) addons; };
in {
  options = {
    i18n.inputMethod.fcitx5 = {
      addons = mkOption {
        type = with types; listOf package;
        default = [];
        example = with pkgs; [ fcitx5-rime ];
        description = ''
          Enabled Fcitx5 addons.
        '';
      };
    };
  };

  config = mkIf (im.enabled == "fcitx5") {
    i18n.inputMethod.package = fcitx5Package;

    environment.variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };

    systemd.user.services.fcitx5-daemon = {
      enable = true;
      script = "${fcitx5Package}/bin/fcitx5";
      wantedBy = [ "graphical-session.target" ];
    };
  };
}
