{ config, lib, pkgs, ... }:

with lib;

let

cfg = config.services.xserver.cmt;
etcPath = "X11/xorg.conf.d";

in {

  options = {

    services.xserver.cmt = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable chrome multitouch input (cmt). Touchpad drivers that are configured for chromebooks.";
      };
      models = mkOption {
        type = types.enum [ "atlas" "banjo" "candy" "caroline" "cave" "celes" "clapper" "cyan" "daisy" "elan" "elm" "enguarde" "eve" "expresso" "falco" "gandof" "glimmer" "gnawty" "heli" "kevin" "kip" "leon" "lulu" "orco" "pbody" "peppy" "pi" "pit" "puppy" "quawks" "rambi" "samus" "snappy" "spring" "squawks" "swanky" "winky" "wolf" "auron_paine" "auron_yuna" "daisy_skate" "nyan_big" "nyan_blaze" "veyron_jaq" "veyron_jerry" "veyron_mighty" "veyron_minnie" "veyron_speedy" ];
        example = "banjo";
        description = ''
          Which models to enable cmt for. Enter the Code Name for your Chromebook.
          Code Name can be found at <https://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices>.
        '';
      };
    }; #closes services
  }; #closes options

  config = mkIf cfg.enable {

    services.xserver.modules = [ pkgs.xf86_input_cmt ];

    environment.etc = {
      "${etcPath}/40-touchpad-cmt.conf" = {
        source = "${pkgs.chromium-xorg-conf}/40-touchpad-cmt.conf";
      };
      "${etcPath}/50-touchpad-cmt-${cfg.models}.conf" = {
        source = "${pkgs.chromium-xorg-conf}/50-touchpad-cmt-${cfg.models}.conf";
      };
      "${etcPath}/60-touchpad-cmt-${cfg.models}.conf" = {
        source = "${pkgs.chromium-xorg-conf}/60-touchpad-cmt-${cfg.models}.conf";
      };
    };

    assertions = [
      {
        assertion = !config.services.libinput.enable;
        message = ''
          cmt and libinput are incompatible, meaning you cannot enable them both.
          To use cmt you need to disable libinput with `services.libinput.enable = false`
          If you haven't enabled it in configuration.nix, it's enabled by default on a
          different xserver module.
        '';
      }
    ];
  };
}
