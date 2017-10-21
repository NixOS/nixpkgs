{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.emacs;

  editorScript = pkgs.writeScriptBin "emacseditor" ''
    #!${pkgs.stdenv.shell}
    if [ -z "$1" ]; then
      exec ${cfg.package}/bin/emacsclient --create-frame --alternate-editor ${cfg.package}/bin/emacs
    else
      exec ${cfg.package}/bin/emacsclient --alternate-editor ${cfg.package}/bin/emacs "$@"
    fi
  '';

in {

  options.services.emacs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable a user service for the Emacs daemon. Use <literal>emacsclient</literal> to connect to the
        daemon. If <literal>true</literal>, <varname>services.emacs.install</varname> is
        considered <literal>true</literal>, whatever its value.
      '';
    };

    install = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to install a user service for the Emacs daemon. Once
        the service is started, use emacsclient to connect to the
        daemon.

        The service must be manually started for each user with
        "systemctl --user start emacs" or globally through
        <varname>services.emacs.enable</varname>.
      '';
    };


    package = mkOption {
      type = types.package;
      default = pkgs.emacs;
      defaultText = "pkgs.emacs";
      description = ''
        emacs derivation to use.
      '';
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, configures emacsclient to be the default editor
        using the EDITOR environment variable.
      '';
    };
  };

  config = mkIf (cfg.enable || cfg.install) {
    systemd.user.services.emacs = {
      description = "Emacs: the extensible, self-documenting text editor";

      serviceConfig = {
        Type      = "forking";
        ExecStart = "${pkgs.bash}/bin/bash -c 'source ${config.system.build.setEnvironment}; exec ${cfg.package}/bin/emacs --daemon'";
        ExecStop  = "${cfg.package}/bin/emacsclient --eval (kill-emacs)";
        Restart   = "always";
      };
    } // optionalAttrs cfg.enable { wantedBy = [ "default.target" ]; };

    environment.systemPackages = [ cfg.package editorScript ];

    environment.variables = {
      # This is required so that GTK applications launched from Emacs
      # get properly themed:
      GTK_DATA_PREFIX = "${config.system.path}";
    } // (if cfg.defaultEditor then {
        EDITOR = mkOverride 900 "${editorScript}/bin/emacseditor";
      } else {});
  };

  meta.doc = ./emacs.xml;
}
