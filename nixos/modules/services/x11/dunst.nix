{ config, lib, pkgs, ... }:

# Maintainer: siddharthist
with lib;

let
  cfg = config.services.dunst;
  notNull = a: ! isNull a;
  dunstConf = with cfg; pkgs.writeText "dunst.conf" ''
    [global]
      ${optionalString (notNull font) ''font = "${cfg.font}"''}
      ${optionalString (notNull allowMarkup) ''allow_markup = "${builtins.toString cfg.allowMarkup}"''}
      ${optionalString (notNull format) ''format = "${format}"''}
      ${optionalString (notNull alignment) ''alignment = "${alignment}"''}
      ${optionalString (notNull geometry) ''geometry = "${geometry}"''}
      ${optionalString (notNull transparency) ''transparency = "${builtins.toString transparency}"''}
    ${extraConfig}
  '';
in {
  ###### interface

  options.services.dunst = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Whether to enable Dunst: ${pkgs.dunst.meta.description}.";
    };

    font = mkOption {
      type = with types; nullOr string;
      default = null;
      example = "Fira Code 20";
      description = "The font that dunst will use in notifications.";
    };

    allowMarkup = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = true;
      description = "Allow a small subset of html markup.";
    };

    format = mkOption {
      type = with types; nullOr string;
      default = null;
      example = "<b>%s</b>\n%b";
      description = "The format of the message (see the Dunst documentation).";
    };

    alignment = mkOption {
      type = with types; nullOr (enum [ "left" "center" "right" ]);
      default = "left";
      example = "right";
      description = "Alignment of text within notification.";
    };

    geometry = mkOption {
      type = with types; nullOr string;
      default = null;
      example = "500x300-40+40";
      description = "The geometry of the window: [{width}]x{height}[+/-{x}+/-{y}]";
    };

    transparency = mkOption {
      type = with types; nullOr int;
      default = null;
      example = 10;
      description = "The transparency of the window.  Range: [0; 100].";
    };

    extraConfig = mkOption {
      type = types.string;
      default = "";
      description = "Extra configuration to append to the config file.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dunst;
      defaultText = "pkgs.dunst";
      description = "dunst derivation to use.";
    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.dunst ];

    systemd.user.services.dunst = {
      #after = [ "graphical.target" ];
      description = "Dunst: lightweight and customizable notification daemon";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/dunst -config ${dunstConf}";
        Restart = "always";
        RestartSec = 3;
      };
      environment.DISPLAY = ":${toString (
          let display = config.services.xserver.display;
          in if display != null then display else 0
        )}";
      };
  };
}
