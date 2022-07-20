{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.security.polkit;

in

{

  options = {

    security.polkit.enable = mkEnableOption "polkit";

    security.polkit.extraConfig = mkOption {
      type = types.lines;
      default = "";
      example =
        ''
          /* Log authorization checks. */
          polkit.addRule(function(action, subject) {
            polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
          });

          /* Allow any local user to do anything (dangerous!). */
          polkit.addRule(function(action, subject) {
            if (subject.local) return "yes";
          });
        '';
      description = lib.mdDoc
        ''
          Any polkit rules to be added to config (in JavaScript ;-). See:
          http://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html#polkit-rules
        '';
    };

    security.polkit.adminIdentities = mkOption {
      type = types.listOf types.str;
      default = [ "unix-group:wheel" ];
      example = [ "unix-user:alice" "unix-group:admin" ];
      description = lib.mdDoc
        ''
          Specifies which users are considered “administrators”, for those
          actions that require the user to authenticate as an
          administrator (i.e. have an `auth_admin`
          value).  By default, this is all users in the `wheel` group.
        '';
    };

  };


  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.polkit.bin pkgs.polkit.out ];

    systemd.packages = [ pkgs.polkit.out ];

    systemd.services.polkit.restartTriggers = [ config.system.path ];
    systemd.services.polkit.stopIfChanged = false;

    # The polkit daemon reads action/rule files
    environment.pathsToLink = [ "/share/polkit-1" ];

    # PolKit rules for NixOS.
    environment.etc."polkit-1/rules.d/10-nixos.rules".text =
      ''
        polkit.addAdminRule(function(action, subject) {
          return [${concatStringsSep ", " (map (i: "\"${i}\"") cfg.adminIdentities)}];
        });

        ${cfg.extraConfig}
      ''; #TODO: validation on compilation (at least against typos)

    services.dbus.packages = [ pkgs.polkit.out ];

    security.pam.services.polkit-1 = {};

    security.wrappers = {
      pkexec =
        { setuid = true;
          owner = "root";
          group = "root";
          source = "${pkgs.polkit.bin}/bin/pkexec";
        };
      polkit-agent-helper-1 =
        { setuid = true;
          owner = "root";
          group = "root";
          source = "${pkgs.polkit.out}/lib/polkit-1/polkit-agent-helper-1";
        };
    };

    systemd.tmpfiles.rules = [
      # Probably no more needed, clean up
      "R /var/lib/polkit-1"
      "R /var/lib/PolicyKit"
    ];

    users.users.polkituser = {
      description = "PolKit daemon";
      uid = config.ids.uids.polkituser;
      group = "polkituser";
    };

    users.groups.polkituser = {};
  };

}

