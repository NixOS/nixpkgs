{ config, lib, pkgs, ... }:
let

  cfg = config.services.emacs;

  editorScript = pkgs.writeShellScriptBin "emacseditor" ''
    if [ -z "$1" ]; then
      exec ${cfg.package}/bin/emacsclient --create-frame --alternate-editor ${cfg.package}/bin/emacs
    else
      exec ${cfg.package}/bin/emacsclient --alternate-editor ${cfg.package}/bin/emacs "$@"
    fi
  '';

in
{

  options.services.emacs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable a user service for the Emacs daemon. Use `emacsclient` to connect to the
        daemon. If `true`, {var}`services.emacs.install` is
        considered `true`, whatever its value.
      '';
    };

    install = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to install a user service for the Emacs daemon. Once
        the service is started, use emacsclient to connect to the
        daemon.

        The service must be manually started for each user with
        "systemctl --user start emacs" or globally through
        {var}`services.emacs.enable`.
      '';
    };


    package = lib.mkPackageOption pkgs "emacs" { };

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        When enabled, configures emacsclient to be the default editor
        using the EDITOR environment variable.
      '';
    };

    startWithGraphical = lib.mkOption {
      type = lib.types.bool;
      default = config.services.xserver.enable;
      defaultText = lib.literalExpression "config.services.xserver.enable";
      description = ''
        Start emacs with the graphical session instead of any session. Without this, emacs clients will not be able to create frames in the graphical session.
      '';
    };
  };

  config = lib.mkIf (cfg.enable || cfg.install) {
    systemd.user.services.emacs = {
      description = "Emacs: the extensible, self-documenting text editor";

      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.runtimeShell} -c 'source ${config.system.build.setEnvironment}; exec ${cfg.package}/bin/emacs --fg-daemon'";
        ExecStop = "${cfg.package}/bin/emacsclient --eval (kill-emacs)";
        Restart = "always";
      };

      unitConfig = lib.optionalAttrs cfg.startWithGraphical {
        After = "graphical-session.target";
      };
    } // lib.optionalAttrs cfg.enable {
      wantedBy = if cfg.startWithGraphical then [ "graphical-session.target" ] else [ "default.target" ];
    };

    environment.systemPackages = [ cfg.package editorScript ];

    environment.variables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkOverride 900 "emacseditor");
  };

  meta.doc = ./emacs.md;
}
