{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.desktopManager.kde;
  xorg = config.services.xserver.package;

  options = { services = { xserver = { desktopManager = {

    kde = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the kde desktop manager.";
      };
    };

  }; }; }; };
in

mkIf cfg.enable {
  require = [
    options

    # environment.kdePackages
    ./kde-environment.nix
  ];

  services = {
    xserver = {

      desktopManager = {
        session = [{
          name = "kde";
          start = ''
            # A quick hack to make KDE screen locking work.  It calls
            # kcheckpass, which needs to be setuid in order to read the
            # shadow password file.  We have a setuid wrapper around
            # kcheckpass.  However, startkde adds $kdebase/bin to the start
            # of $PATH if it's not already in $PATH, thus overriding the
            # setuid wrapper directory.  So here we add $kdebase/bin to the
            # end of $PATH to keep startkde from doing that.
            export PATH=$PATH:${pkgs.kdebase}/bin
            
            # Start KDE.
            exec ${pkgs.kdebase}/bin/startkde
          '';
        }];
      };

    };
  };

  security = {
    extraSetuidPrograms = [
      "kcheckpass"
    ];
  };

  environment = {
    kdePackages = [
      pkgs.kdelibs
      pkgs.kdebase
    ];

    extraPackages = [
      xorg.xset # used by startkde, non-essential
    ];

    etc = [
      { source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
        target = "X11/xkb";
      }
    ];
  };
}
