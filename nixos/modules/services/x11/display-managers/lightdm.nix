{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  xEnv = config.systemd.services."display-manager".environment;
  cfg = dmcfg.lightdm;

  inherit (pkgs) stdenv lightdm writeScript writeText;

  # lightdm runs with clearenv(), but we need a few things in the enviornment for X to startup
  xserverWrapper = writeScript "xserver-wrapper"
    ''
      #! /bin/sh
      ${concatMapStrings (n: "export ${n}=\"${getAttr n xEnv}\"\n") (attrNames xEnv)}
      exec ${dmcfg.xserverBin} ${dmcfg.xserverArgs}
    '';

  # The default greeter provided with this expression is the GTK greeter.
  # Again, we need a few things in the environment for the greeter to run with
  # fonts/icons.
  wrappedGtkGreeter = stdenv.mkDerivation {
    name = "lightdm-gtk-greeter";
    buildInputs = [ pkgs.makeWrapper ];

    buildCommand = ''
      mkdir -p $out/gtk-3.0/

      # This wrapper ensures that we actually get fonts
      makeWrapper ${pkgs.lightdm_gtk_greeter}/sbin/lightdm-gtk-greeter \
        $out/greeter \
        --set XDG_DATA_DIRS ${pkgs.gnome2.gnome_icon_theme}/share \
        --set FONTCONFIG_FILE /etc/fonts/fonts.conf \
        --set XDG_CONFIG_HOME $out/

      # We need this to ensure that it actually tries to find icons from gnome-icon-theme
      cat - > $out/gtk-3.0/settings.ini << EOF
      [Settings]
      gtk-icon-theme-name=gnome
      EOF

      cat - > $out/lightdm-gtk-greeter.desktop << EOF
      [Desktop Entry]
      Name=LightDM Greeter
      Comment=This runs the LightDM Greeter
      Exec=$out/greeter
      Type=Application
      EOF
    '';
  };

  lightdmConf = writeText "lightdm.conf"
    ''
      [LightDM]
      greeter-user = ${config.users.extraUsers.lightdm.name}
      greeters-directory = ${cfg.greeter.package}
      sessions-directory = ${dmcfg.session.desktops}

      [SeatDefaults]
      xserver-command = ${xserverWrapper}
      session-wrapper = ${dmcfg.session.script}
      greeter-session = ${cfg.greeter.name}
    '';

in
{
  options = {
    services.xserver.displayManager.lightdm = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable lightdm as the display manager.
        '';
      };

      greeter = mkOption {
        description = ''
          The LightDM greeter to login via. The package should be a directory
          containing a .desktop file matching the name in the 'name' option.
        '';
        default = {
          name = "lightdm-gtk-greeter";
          package = wrappedGtkGreeter;
        };
      };
    };
  };

  config = mkIf cfg.enable {

    services.xserver.displayManager.slim.enable = false;

    services.xserver.displayManager.job = {
      logsXsession = true;

      # lightdm relaunches itself via just `lightdm`, so needs to be on the PATH
      execCmd = ''
        export PATH=${lightdm}/sbin:$PATH
        ${lightdm}/sbin/lightdm --log-dir=/var/log --run-dir=/run --config=${lightdmConf}
      '';
    };

    services.dbus.enable = true;
    services.dbus.packages = [ lightdm ];

    security.pam.services.lightdm = { allowNullPassword = true; startSession = true; };
    security.pam.services.lightdm-greeter = { allowNullPassword = true; startSession = true; };

    users.extraUsers.lightdm = {
      createHome = true;
      home = "/var/lib/lightdm";
      group = "lightdm";
      uid = config.ids.uids.lightdm;
    };

    users.extraGroups.lightdm.gid = config.ids.gids.lightdm;
  };
}
