{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf types;
  kdePackages = config.environment.kdePackages;

  options = {

    environment = {

      kdePackages = mkOption {
        default = [];
        example = [ pkgs.kde4.kdegames ];
        type = types.list types.package;
        description = ''
          Additional KDE packages to be used when you use KDE as a desktop
          manager.  By default, you only get the KDE base packages.
        '';
      };

    };
  };
in

mkIf (kdePackages != [] && config.services.xserver.enable) {
  require = options;

  environment = {
    x11Packages = kdePackages;

    shellInit = ''
      export KDEDIRS="${pkgs.lib.concatStringsSep ":" kdePackages}"
      export XDG_CONFIG_DIRS="${pkgs.lib.makeSearchPath "etc/xdg" kdePackages}"
      export XDG_DATA_DIRS="${pkgs.lib.makeSearchPath "share" kdePackages}"
    '';
  };
}
