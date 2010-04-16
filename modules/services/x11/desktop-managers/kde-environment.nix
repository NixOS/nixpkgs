{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkDefaultValue mkOption mkIf types;
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
          Just adds packages to systemPackages and x11Packages. Will be removed
          in the future.
        '';
      };

    };
  };
in

mkIf (kdePackages != [] && config.services.xserver.enable) {
  require = options;

  environment = {
    x11Packages = kdePackages;
    systemPackages = kdePackages;
    pathsToLink = [ "/share" "/plugins" ];
  };
}
