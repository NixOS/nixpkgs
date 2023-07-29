{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.emacs;

  editorScript = pkgs.writeScriptBin "emacseditor" ''
    #!${pkgs.runtimeShell}
    if [ -z "$1" ]; then
      exec ${cfg.package}/bin/emacsclient --create-frame --alternate-editor ${cfg.package}/bin/emacs
    else
      exec ${cfg.package}/bin/emacsclient --alternate-editor ${cfg.package}/bin/emacs "$@"
    fi
  '';

  desktopApplicationFile = pkgs.writeTextFile {
    name = "emacsclient.desktop";
    destination = "/share/applications/emacsclient.desktop";
    text = ''
      [Desktop Entry]
      Name=Emacsclient
      GenericName=Text Editor
      Comment=Edit text
      MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
      Exec=emacseditor %F
      Icon=emacs
      Type=Application
      Terminal=false
      Categories=Development;TextEditor;
      StartupWMClass=Emacs
      Keywords=Text;Editor;
    '';
  };

in
{

  options.services.emacs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable a user service for the Emacs daemon. Use `emacsclient` to connect to the
        daemon. If `true`, {var}`services.emacs.install` is
        considered `true`, whatever its value.
      '';
    };

    install = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to install a user service for the Emacs daemon. Once
        the service is started, use emacsclient to connect to the
        daemon.

        The service must be manually started for each user with
        "systemctl --user start emacs" or globally through
        {var}`services.emacs.enable`.
      '';
    };


    package = mkOption {
      type = types.package;
      default = pkgs.emacs;
      defaultText = literalExpression "pkgs.emacs";
      description = lib.mdDoc ''
        emacs derivation to use.
      '';
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        When enabled, configures emacsclient to be the default editor
        using the EDITOR environment variable.
      '';
    };

    startWithGraphical = mkOption {
      type = types.bool;
      default = config.services.xserver.enable;
      defaultText = literalExpression "config.services.xserver.enable";
      description = lib.mdDoc ''
        Start emacs with the graphical session instead of any session. Without this, emacs clients will not be able to create frames in the graphical session.
      '';
    };
  };

  config = mkIf (cfg.enable || cfg.install) {
    systemd.user.services.emacs = {
      description = "Emacs: the extensible, self-documenting text editor";

      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.bash}/bin/bash -c 'source ${config.system.build.setEnvironment}; exec ${cfg.package}/bin/emacs --daemon'";
        ExecStop = "${cfg.package}/bin/emacsclient --eval (kill-emacs)";
        Restart = "always";
      };

      unitConfig = optionalAttrs cfg.startWithGraphical {
        After = "graphical-session.target";
      };
    } // optionalAttrs cfg.enable {
      wantedBy = if cfg.startWithGraphical then [ "graphical-session.target" ] else [ "default.target" ];
    };

    environment.systemPackages = [ cfg.package editorScript desktopApplicationFile ];

    environment.variables.EDITOR = mkIf cfg.defaultEditor (mkOverride 900 "emacseditor");
  };

  meta.doc = ./emacs.md;
}
