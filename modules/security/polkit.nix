{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.security.polkit;

in

{

  options = {

    security.polkit.enable = mkOption {
      default = true;
      description = "Whether to enable PolKit.";
    };

    security.polkit.permissions = mkOption {
      default = "";
      example =
        ''
          [Disallow Users To Suspend]
          Identity=unix-group:users
          Action=org.freedesktop.upower.*
          ResultAny=no
          ResultInactive=no
          ResultActive=no

          [Allow Anybody To Eject Disks]
          Identity=unix-user:*
          Action=org.freedesktop.udisks.drive-eject
          ResultAny=yes
          ResultInactive=yes
          ResultActive=yes

          [Allow Alice To Mount Filesystems After Admin Authentication]
          Identity=unix-user:alice
          Action=org.freedesktop.udisks.filesystem-mount
          ResultAny=auth_admin
          ResultInactive=auth_admin
          ResultActive=auth_admin
        '';
      description =
        ''
          Allows the default permissions of privileged actions to be overridden.
        '';
    };

    security.polkit.adminIdentities = mkOption {
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

    # The polkit daemon reads action files
    environment.pathsToLink = [ "/share/polkit-1/actions" ];

    environment.etc =
      [ # No idea what the "null backend" is, but it seems to need this.
        { source = "${pkgs.polkit}/etc/polkit-1/nullbackend.conf.d";
          target = "polkit-1/nullbackend.conf.d";
        }

        # This file determines what users are considered
        # "administrators".
        { source = pkgs.writeText "10-nixos.conf"
            ''
              [Configuration]
              AdminIdentities=${cfg.adminIdentities}
            '';
          target = "polkit-1/localauthority.conf.d/10-nixos.conf";
        }

        { source = pkgs.writeText "org.nixos.pkla" cfg.permissions;
          target = "polkit-1/localauthority/10-vendor.d/org.nixos.pkla";
        }
      ];

    services.dbus.packages = [ pkgs.polkit ];

    security.pam.services = [ { name = "polkit-1"; } ];

    security.setuidPrograms = [ "pkexec" ];

    security.setuidOwners = singleton
      { program = "polkit-agent-helper-1";
        owner = "root";
        group = "root";
        setuid = true;
        source = "${pkgs.polkit}/libexec/polkit-1/polkit-agent-helper-1";
      };

    system.activationScripts.polkit =
      ''
        mkdir -p /var/lib/polkit-1/localauthority
        chmod 700 /var/lib/polkit-1{/localauthority,}

        # Force polkitd to be restarted so that it reloads its
        # configuration.
        ${pkgs.procps}/bin/pkill -INT -u root -x polkitd
      '';

  };

}
