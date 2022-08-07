{ config, lib, pkgs, ... }:

# NOTE for now nothing is installed into /etc/bee-clef/. the config files are used as read-only from the nix store.

with lib;
let
  cfg = config.services.bee-clef;
in {
  meta = {
    maintainers = with maintainers; [ attila-lendvai ];
  };

  ### interface

  options = {
    services.bee-clef = {
      enable = mkEnableOption "clef external signer instance for Ethereum Swarm Bee";

      dataDir = mkOption {
        type = types.nullOr types.str;
        default = "/var/lib/bee-clef";
        description = lib.mdDoc ''
          Data dir for bee-clef. Beware that some helper scripts may not work when changed!
          The service itself should work fine, though.
        '';
      };

      passwordFile = mkOption {
        type = types.nullOr types.str;
        default = "/var/lib/bee-clef/password";
        description = lib.mdDoc "Password file for bee-clef.";
      };

      user = mkOption {
        type = types.str;
        default = "bee-clef";
        description = lib.mdDoc ''
          User the bee-clef daemon should execute under.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "bee-clef";
        description = lib.mdDoc ''
          Group the bee-clef daemon should execute under.
        '';
      };
    };
  };

  ### implementation

  config = mkIf cfg.enable {
    # if we ever want to have rules.js under /etc/bee-clef/
    # environment.etc."bee-clef/rules.js".source = ${pkgs.bee-clef}/rules.js

    systemd.packages = [ pkgs.bee-clef ]; # include the upstream bee-clef.service file

    systemd.tmpfiles.rules = [
        "d '${cfg.dataDir}/'         0750 ${cfg.user} ${cfg.group}"
        "d '${cfg.dataDir}/keystore' 0700 ${cfg.user} ${cfg.group}"
      ];

    systemd.services.bee-clef = {
      path = [
        # these are needed for the ensure-clef-account script
        pkgs.coreutils
        pkgs.gnused
        pkgs.gawk
      ];

      wantedBy = [ "bee.service" "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStartPre = ''${pkgs.bee-clef}/share/bee-clef/ensure-clef-account "${cfg.dataDir}" "${pkgs.bee-clef}/share/bee-clef/"'';
        ExecStart = [
          "" # this hides/overrides what's in the original entry
          "${pkgs.bee-clef}/share/bee-clef/bee-clef-service start"
        ];
        ExecStop = [
          "" # this hides/overrides what's in the original entry
          "${pkgs.bee-clef}/share/bee-clef/bee-clef-service stop"
        ];
        Environment = [
          "CONFIGDIR=${cfg.dataDir}"
          "PASSWORD_FILE=${cfg.passwordFile}"
        ];
      };
    };

    users.users = optionalAttrs (cfg.user == "bee-clef") {
      bee-clef = {
        group = cfg.group;
        home = cfg.dataDir;
        isSystemUser = true;
        description = "Daemon user for the bee-clef service";
      };
    };

    users.groups = optionalAttrs (cfg.group == "bee-clef") {
      bee-clef = {};
    };
  };
}
