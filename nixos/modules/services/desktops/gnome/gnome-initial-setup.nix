# GNOME Initial Setup.

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.gnome.gnome-initial-setup;

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

  settingsFormat = pkgs.formats.ini {
    listToValue = l: lib.concatStringsSep ";" (map (s: lib.generators.mkValueStringDefault { } s) l);
  };
  configFile = settingsFormat.generate "vendor.conf" cfg.settings;
in

{

  meta = {
    teams = [ lib.teams.gnome ];
  };

  ###### interface

  options = {

    services.gnome.gnome-initial-setup = {

      enable = lib.mkEnableOption "GNOME Initial Setup, a Simple, easy, and safe way to prepare a new system";

      settings = lib.mkOption {
        type = settingsFormat.type;
        default = { };
        example = {
          pages.skip = [
            "welcome"
            "language"
            "keyboard"
            "network"
            "privacy"
            "timezone"
            "software"
            "account"
            "password"
            "parental_controls"
            "parent_password"
            "summary"
          ];
        };
        description = ''
          Vendor configuration to customise the initial setup dialogue.
          See [here](https://gitlab.gnome.org/GNOME/gnome-initial-setup#vendor-configuration) for supported options.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.gnome.gnome-initial-setup.settings = {
      pages = {
        skip = lib.mkBefore (
          if lib.versionOlder config.system.stateVersion "26.11" then
            [
              "account"
              "software"
              "password"
              "timezone"
            ]
          else
            [
              "software"
            ]
            ++ lib.optional (!config.i18n.imperativeLocale) "language"
            ++ lib.optional (config.time.timeZone != null) "timezone"
            ++ lib.optionals (!config.users.mutableUsers) [
              "account"
              "password"
              "parental_controls"
              "parent_password"
            ]
        );
      };
    };

    environment.systemPackages = [
      pkgs.gnome-initial-setup
    ]
    ++ lib.optional (lib.versionOlder config.system.stateVersion "20.03") createGisStampFilesAutostart;

    environment.etc."gnome-initial-setup/vendor.conf".source = configFile;

    services.displayManager.gdm.extraPackages = [
      pkgs.gnome-initial-setup
    ];

    systemd.packages = [
      pkgs.gnome-initial-setup
    ];

    systemd.user.targets."gnome-session".wants = [
      "gnome-initial-setup-first-login.service"
    ];

    systemd.user.targets."graphical-session-pre".wants = [
      "gnome-initial-setup-copy-worker.service"
    ];

    programs.dconf.profiles.gnome-initial-setup.databases = [
      "${pkgs.gnome-initial-setup}/share/gnome-initial-setup/initial-setup-dconf-defaults"
    ];

    users = {
      users.gnome-initial-setup = {
        isSystemUser = true;
        group = "gnome-initial-setup";
        home = "/run/gdm/home/gnome-initial-setup";
        description = "GNOME Initial Setup user";
      };

      # TODO: switch to using provided gnome-initial-setup sysusers.d
      groups.gnome-initial-setup = { };
    };
  };

}
