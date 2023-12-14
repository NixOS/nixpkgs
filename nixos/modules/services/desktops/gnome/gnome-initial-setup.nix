# GNOME Initial Setup.

{ config, pkgs, lib, ... }:

with lib;

let

  # GNOME initial setup's run is conditioned on whether
  # the gnome-initial-setup-done file exists in XDG_CONFIG_HOME
  # Because of this, every existing user will have initial setup
  # running because they never ran it before.
  #
  # To prevent this we create the file if the users stateVersion
  # is older than 20.03 (the release we added this module).

  script = pkgs.writeScript "create-gis-stamp-files" ''
    #!${pkgs.runtimeShell}
    setup_done=$HOME/.config/gnome-initial-setup-done

    echo "Creating g-i-s stamp file $setup_done ..."
    cat - > $setup_done <<- EOF
    yes
    EOF
  '';

  createGisStampFilesAutostart = pkgs.writeTextFile rec {
    name = "create-g-i-s-stamp-files";
    destination = "/etc/xdg/autostart/${name}.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Create GNOME Initial Setup stamp files
      Exec=${script}
      StartupNotify=false
      NoDisplay=true
      OnlyShowIn=GNOME;
      AutostartCondition=unless-exists gnome-initial-setup-done
      X-GNOME-Autostart-Phase=EarlyInitialization
    '';
  };

in

{

  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2021-05-07
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gnome-initial-setup" "enable" ]
      [ "services" "gnome" "gnome-initial-setup" "enable" ]
    )
  ];

  ###### interface

  options = {

    services.gnome.gnome-initial-setup = {

      enable = mkEnableOption (lib.mdDoc "GNOME Initial Setup, a Simple, easy, and safe way to prepare a new system");

    };

  };


  ###### implementation

  config = mkIf config.services.gnome.gnome-initial-setup.enable {

    environment.systemPackages = [
      pkgs.gnome.gnome-initial-setup
    ]
    ++ optional (versionOlder config.system.stateVersion "20.03") createGisStampFilesAutostart
    ;

    systemd.packages = [
      pkgs.gnome.gnome-initial-setup
    ];

    systemd.user.targets."gnome-session".wants = [
      "gnome-initial-setup-copy-worker.service"
      "gnome-initial-setup-first-login.service"
      "gnome-welcome-tour.service"
    ];

    systemd.user.targets."gnome-session@gnome-initial-setup".wants = [
      "gnome-initial-setup.service"
    ];

    programs.dconf.profiles.gnome-initial-setup.databases = [
      "${pkgs.gnome.gnome-initial-setup}/share/gnome-initial-setup/initial-setup-dconf-defaults"
    ];
  };

}
