{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.jackline;
in {
  options.services.jackline = {
    enable = mkOption {
      description = ''
        Whether to enable jackline, a minimalistic secure XMPP client in OCaml.

        By doing so, jackline will be run in a screen session. One can attach
        this session via <literal>sudo -u jackline screen -x jackline-screen</literal>.
      '';
      type = types.bool;
      default = false;
      example = true;
    };

    root = mkOption {
      description = "Jackline state directory.";
      type = types.str;
      default = "/var/lib/jackline";
    };

    sessionName = mkOption {
      description = "Name of the `screen' session for jackline.";
      default = "jackline-screen";
      type = types.str;
    };

    package = mkOption {
      type = types.package;
      description = "Package that should be used for jackline.";
      default = pkgs.jackline;
      defaultText = "pkgs.jackline";
    };
  };

  config = mkIf cfg.enable {
    users = {
      groups.jackline = {};

      users.jackline = {
        createHome = true;
        group = "jackline";
        home = cfg.root;
        isSystemUser = true;
      };
    };

    security.wrappers.screen = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.screen}/bin/screen";
    };

    systemd.services.jackline = {
      description = "jackline, a minimalistic secure XMPP client in OCaml";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "exec";
        ExecStart = "${config.security.wrapperDir}/screen -Dm -S ${cfg.sessionName} ${cfg.package}/bin/jackline";

        User = "jackline";
        Group = "jackline";

        RemainAfterExit = "yes";

        ProtectSystem = "strict";
        ReadWritePaths = "${cfg.root} /tmp/screens/";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ oxzi ];
}
