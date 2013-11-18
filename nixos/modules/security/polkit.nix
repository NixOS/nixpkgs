{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.security.polkit;

in

{

  options = {

    security.polkit.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable PolKit.";
    };

    security.polkit.extraConfig = mkOption {
      type = types.lines;
      default = "";
      example =
        ''
          TODO
        '';
      description =
        ''
          Any polkit rules to be added to config (in JavaScript ;-). See:
          http://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html#polkit-rules
        '';
    };

    security.polkit.adminIdentities = mkOption {
      type = types.str;
      default = "unix-user:0;unix-group:wheel";
      example = "";
      description =
        ''
          Specifies which users are considered “administrators”, for those
          actions that require the user to authenticate as an
          administrator (i.e. have an <literal>auth_admin</literal>
          value).  By default, this is the <literal>root</literal>
          user and all users in the <literal>wheel</literal> group.
        '';
    };

  };


  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.polkit ];

    systemd.packages = [ pkgs.polkit ];

    # The polkit daemon reads action/rule files
    environment.pathsToLink = [ "/share/polkit-1" ];

    # PolKit rules for NixOS.
    environment.etc."polkit-1/rules.d/10-nixos.rules".text =
      ''
        polkit.addAdminRule(function(action, subject) {
          return ["${cfg.adminIdentities}"];
        });

        ${cfg.extraConfig}
      ''; #TODO: validation on compilation (at least against typos)

    services.dbus.packages = [ pkgs.polkit ];

    security.pam.services.polkit-1 = {};

    security.setuidPrograms = [ "pkexec" ];

    security.setuidOwners = [
      { program = "polkit-agent-helper-1";
        owner = "root";
        group = "root";
        setuid = true;
        source = "${pkgs.polkit}/lib/polkit-1/polkit-agent-helper-1";
      }
    ];

    system.activationScripts.polkit =
      ''
        # Probably no more needed, clean up
        rm -rf /var/lib/{polkit-1,PolicyKit}

        # Force polkitd to be restarted so that it reloads its
        # configuration.
        ${pkgs.procps}/bin/pkill -INT -u root -x polkitd
      '';

    users.extraUsers.polkituser = {
      description = "PolKit daemon";
      uid = config.ids.uids.polkituser;
    };

  };

}

